// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";

// === AOS (entrées au scroll) ===
import "aos/dist/aos.css";
import AOS from "aos";

// Helper: run on first load + every Turbo load
const onReady = (fn) => {
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", fn, { once: true });
  } else {
    fn();
  }
  document.addEventListener("turbo:load", fn);
};

// ---- AOS ----
let aosInited = false;
function initAOS() {
  const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  const opts = {
    duration: 700,
    easing: "ease-out-cubic",
    offset: 80,
    once: true,
    mirror: false,
    disable: reduce,
  };
  if (aosInited) {
    AOS.refreshHard();
  } else {
    AOS.init(opts);
    aosInited = true;
  }
}

// ---- Particules (canvas#stars) ----
function initStars() {
  const c = document.getElementById("stars");
  if (!c || c.dataset.bound) return;
  c.dataset.bound = "1";

  const ctx = c.getContext("2d");
  let w, h, dpr, rafId;

  const stars = Array.from({ length: 140 }, () => ({
    x: 0, y: 0, r: 0, a: 0, vx: 0, vy: 0, alpha: 0,
  }));

  function resize() {
    dpr = Math.max(1, window.devicePixelRatio || 1);
    w = c.clientWidth;
    h = c.clientHeight;
    c.width = Math.round(w * dpr);
    c.height = Math.round(h * dpr);
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  }

  function reset(s) {
    s.x = Math.random() * w;
    s.y = Math.random() * h;
    s.r = Math.random() * 1.6 + 0.2;
    s.vx = (Math.random() - 0.5) * 0.05;
    s.vy = (Math.random() - 0.5) * 0.05;
    s.alpha = Math.random() * 0.6 + 0.2;
    s.a = Math.random() * Math.PI * 2;
  }

  resize();
  stars.forEach(reset);
  const onResize = () => resize();
  window.addEventListener("resize", onResize);

  const pref = window.matchMedia("(prefers-reduced-motion: reduce)");
  function frame() {
    if (pref.matches || !document.body.contains(c)) return; // stop if removed
    ctx.clearRect(0, 0, w, h);
    ctx.fillStyle = "#fff";
    for (const s of stars) {
      s.x += s.vx;
      s.y += s.vy;
      if (s.x < -5 || s.x > w + 5 || s.y < -5 || s.y > h + 5) reset(s);
      ctx.globalAlpha = s.alpha + Math.sin((s.a += 0.02)) * 0.1;
      ctx.beginPath();
      ctx.arc(s.x, s.y, s.r, 0, Math.PI * 2);
      ctx.fill();
    }
    ctx.globalAlpha = 1;
    rafId = requestAnimationFrame(frame);
  }
  rafId = requestAnimationFrame(frame);

  // Cleanup avant mise en cache Turbo
  document.addEventListener(
    "turbo:before-cache",
    () => {
      cancelAnimationFrame(rafId);
      window.removeEventListener("resize", onResize);
      // reset width/height pour éviter canvas fantôme
      c.width = c.width;
    },
    { once: true }
  );
}

// ---- Tilt 3D léger ----
function initTilt() {
  if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;

  document.querySelectorAll(".tilt").forEach((card) => {
    if (card.dataset.tiltBound) return;
    card.dataset.tiltBound = "1";

    const max = parseFloat(card.dataset.tiltMax || "6");
    const scale = parseFloat(card.dataset.tiltScale || "1.02");

    const onMove = (e) => {
      const r = card.getBoundingClientRect();
      const px = (e.clientX - r.left) / r.width;
      const py = (e.clientY - r.top) / r.height;
      const rx = (0.5 - py) * (max * 2);
      const ry = (px - 0.5) * (max * 2);
      card.style.transform = `perspective(900px) rotateX(${rx}deg) rotateY(${ry}deg) scale(${scale})`;
      card.style.willChange = "transform";
    };
    const reset = () => {
      card.style.transform = "";
      card.style.willChange = "auto";
    };

    card.addEventListener("mousemove", onMove);
    ["mouseleave", "blur"].forEach((ev) => card.addEventListener(ev, reset));

    document.addEventListener(
      "turbo:before-cache",
      () => {
        card.removeEventListener("mousemove", onMove);
        ["mouseleave", "blur"].forEach((ev) => card.removeEventListener(ev, reset));
        reset();
      },
      { once: true }
    );
  });
}

// ---- Navbar compacte (#mainNav[data-shrink]) ----
function initShrinkingNav() {
  const nav = document.querySelector("#mainNav[data-shrink]");
  if (!nav || nav.dataset.bound) return;
  nav.dataset.bound = "1";

  const apply = () => {
    const scrolled = window.scrollY > 16;
    nav.classList.toggle("shadow-md", scrolled);
    nav.classList.toggle("py-2", scrolled);
    nav.classList.toggle("py-4", !scrolled);
  };
  apply();

  const onScroll = () => apply();
  document.addEventListener("scroll", onScroll, { passive: true });

  document.addEventListener(
    "turbo:before-cache",
    () => document.removeEventListener("scroll", onScroll),
    { once: true }
  );
}

// ---- Lazy-load iframes (data-src) ----
function initLazyIframes() {
  const frames = document.querySelectorAll("iframe[data-src]");
  if (!frames.length) return;

  const io = new IntersectionObserver(
    (entries) => {
      entries.forEach(({ target, isIntersecting }) => {
        if (!isIntersecting) return;
        const src = target.getAttribute("data-src");
        target.addEventListener(
          "load",
          () => {
            target.classList.remove("opacity-0");
            const skeleton = target.parentElement?.querySelector(".animate-pulse");
            if (skeleton) skeleton.remove();
          },
          { once: true }
        );
        target.setAttribute("src", src);
        target.setAttribute("loading", "lazy");
        io.unobserve(target);
      });
    },
    { rootMargin: "200px" }
  );

  frames.forEach((f) => io.observe(f));
  document.addEventListener("turbo:before-cache", () => io.disconnect(), { once: true });
}

// ---- Carousels ----
function initCarousel(root) {
  if (root.dataset.carouselBound) return;
  root.dataset.carouselBound = "1";

  const slides = Array.from(root.querySelectorAll(".carousel-slide"));
  const dots = Array.from(root.querySelectorAll(".carousel-dot"));
  if (!slides.length) return;

  const autoplay = root.dataset.autoplay === "true";
  const intervalMs = parseInt(root.dataset.interval || "4000", 10);
  const pauseOnHover = root.dataset.pauseOnHover === "true";

  let i = 0;
  let timer = null;

  const update = () => {
    slides.forEach((el, idx) => el.classList.toggle("hidden", idx !== i));
    dots.forEach((d, idx) => {
      d.classList.toggle("bg-slate-900", idx === i);
      d.classList.toggle("bg-slate-300", idx !== i);
    });
  };
  const show = (n) => {
    i = (n + slides.length) % slides.length;
    update();
  };

  root.querySelector('[data-action="prev"]')?.addEventListener("click", () => show(i - 1));
  root.querySelector('[data-action="next"]')?.addEventListener("click", () => show(i + 1));
  dots.forEach((btn) => btn.addEventListener("click", () => show(parseInt(btn.dataset.goto, 10))));

  root.setAttribute("tabindex", "0");
  root.addEventListener("keydown", (e) => {
    if (e.key === "ArrowLeft") show(i - 1);
    if (e.key === "ArrowRight") show(i + 1);
  });

  const stop = () => {
    if (timer) {
      clearInterval(timer);
      timer = null;
    }
  };
  const start = () => {
    if (!autoplay) return;
    stop();
    timer = setInterval(() => show(i + 1), intervalMs);
  };

  if (pauseOnHover) {
    root.addEventListener("mouseenter", stop);
    root.addEventListener("mouseleave", start);
    root.addEventListener("touchstart", stop, { passive: true });
    root.addEventListener("touchend", start);
  }

  update();
  start();

  document.addEventListener(
    "turbo:before-cache",
    () => {
      stop();
    },
    { once: true }
  );
}

function initCarousels() {
  document
    .querySelectorAll('[id^="carousel-"],[data-carousel]')
    .forEach((root) => initCarousel(root));
}

// ---- Boot ----
function boot() {
  initAOS();
  initStars();
  initTilt();
  initShrinkingNav();
  initLazyIframes();
  initCarousels();
}

onReady(boot);
