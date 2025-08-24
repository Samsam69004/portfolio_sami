// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// === AOS (entrées au scroll) ===
import AOS from "aos";
document.addEventListener("DOMContentLoaded", () => {
  const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  AOS.init({
    duration: 700, easing: "ease-out-cubic", offset: 80,
    once: true, mirror: false, disable: reduce,
  });
});

// === Particules (fond discret) pour <canvas id="stars"> ===
document.addEventListener("DOMContentLoaded", () => {
  const c = document.getElementById("stars");
  if (!c) return;
  const ctx = c.getContext("2d");
  let w, h, dpr;
  const stars = Array.from({ length: 140 }, () => ({ x:0,y:0,r:0,a:0,vx:0,vy:0,alpha:0 }));

  function resize() {
    dpr = Math.max(1, window.devicePixelRatio || 1);
    w = c.clientWidth; h = c.clientHeight;
    c.width = Math.round(w * dpr); c.height = Math.round(h * dpr);
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  }
  function reset(s) {
    s.x = Math.random() * w; s.y = Math.random() * h;
    s.r = Math.random() * 1.6 + 0.2;
    s.vx = (Math.random() - 0.5) * 0.05;
    s.vy = (Math.random() - 0.5) * 0.05;
    s.alpha = Math.random() * 0.6 + 0.2;
    s.a = Math.random() * Math.PI * 2;
  }

  resize(); stars.forEach(reset);
  window.addEventListener("resize", resize);

  const pref = window.matchMedia("(prefers-reduced-motion: reduce)");
  (function frame(){
    if (pref.matches) return;
    ctx.clearRect(0, 0, w, h);
    ctx.fillStyle = "#fff";
    for (const s of stars) {
      s.x += s.vx; s.y += s.vy;
      if (s.x < -5 || s.x > w+5 || s.y < -5 || s.y > h+5) reset(s);
      ctx.globalAlpha = s.alpha + Math.sin((s.a += 0.02)) * 0.1;
      ctx.beginPath(); ctx.arc(s.x, s.y, s.r, 0, Math.PI * 2); ctx.fill();
    }
    ctx.globalAlpha = 1;
    requestAnimationFrame(frame);
  })();
});

// === Tilt 3D léger au hover (ajoute .tilt sur tes cartes) ===
document.addEventListener("DOMContentLoaded", () => {
  if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
  document.querySelectorAll(".tilt").forEach(card => {
    const max = parseFloat(card.dataset.tiltMax || "6");
    const scale = parseFloat(card.dataset.tiltScale || "1.02");
    const reset = () => { card.style.transform = ""; card.style.willChange = "auto"; };
    card.addEventListener("mousemove", (e) => {
      const r = card.getBoundingClientRect();
      const px = (e.clientX - r.left) / r.width;
      const py = (e.clientY - r.top) / r.height;
      const rx = (0.5 - py) * (max * 2);
      const ry = (px - 0.5) * (max * 2);
      card.style.transform = `perspective(900px) rotateX(${rx}deg) rotateY(${ry}deg) scale(${scale})`;
      card.style.willChange = "transform";
    });
    ["mouseleave","blur"].forEach(ev => card.addEventListener(ev, reset));
  });
});

// === Navbar compacte (ajoute id="mainNav" data-shrink sur ta nav) ===
document.addEventListener("DOMContentLoaded", () => {
  const nav = document.querySelector("#mainNav[data-shrink]");
  if (!nav) return;
  const apply = () => {
    const scrolled = window.scrollY > 16;
    nav.classList.toggle("shadow-md", scrolled);
    nav.classList.toggle("py-2", scrolled);
    nav.classList.toggle("py-4", !scrolled);
  };
  apply();
  document.addEventListener("scroll", apply, { passive: true });
});

// === Lazy-load de tes iframes PDF (si section certifs) ===
document.addEventListener("DOMContentLoaded", () => {
  const frames = document.querySelectorAll("iframe[data-src]");
  if (!frames.length) return;
  const io = new IntersectionObserver((entries) => {
    entries.forEach(({ target, isIntersecting }) => {
      if (!isIntersecting) return;
      const src = target.getAttribute("data-src");
      target.addEventListener("load", () => {
        target.classList.remove("opacity-0");
        const skeleton = target.parentElement?.querySelector(".animate-pulse");
        if (skeleton) skeleton.remove();
      }, { once: true });
      target.setAttribute("src", src);
      target.setAttribute("loading", "lazy");
      io.unobserve(target);
    });
  }, { rootMargin: "200px" });
  frames.forEach(f => io.observe(f));
});
