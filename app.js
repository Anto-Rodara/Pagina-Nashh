    const toggle = document.querySelector(".menu-toggle");
    const menu = document.querySelector("#menu-panel");

    toggle.addEventListener("click", () => {
      const isOpen = menu.classList.toggle("open");
      toggle.setAttribute("aria-expanded", String(isOpen));
      toggle.textContent = isOpen ? "Cerrar ♡" : "Menú ♡";
    });

    menu.addEventListener("click", (event) => {
      if (event.target.closest("a")) {
        menu.classList.remove("open");
        toggle.setAttribute("aria-expanded", "false");
        toggle.textContent = "Menú ♡";
      }
    });

    document.querySelector(".brand").addEventListener("click", () => {
      document.querySelector("#inicio").scrollIntoView({ behavior: "smooth" });
    });
