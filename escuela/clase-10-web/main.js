const cursos = [
    { nombre: "Alquimia Básica",    icono: "⚗",  nivel: "Principiante", duracion: "4 semanas" },
    { nombre: "Runas Antiguas",     icono: "ᚱ",  nivel: "Intermedio",   duracion: "6 semanas" },
    { nombre: "Invocación",         icono: "🔮", nivel: "Avanzado",     duracion: "8 semanas" },
    { nombre: "Herrería Mágica",    icono: "⚒",  nivel: "Principiante", duracion: "5 semanas" },
    { nombre: "Cartografía Arcana", icono: "🗺", nivel: "Intermedio",   duracion: "3 semanas" },
    { nombre: "Destilación Lunar",  icono: "🌙", nivel: "Experto",      duracion: "10 semanas" },
];

const grid        = document.getElementById("grid-cursos");
const selectCurso = document.getElementById("curso");

cursos.forEach(c => {
    const card = document.createElement("div");
    card.className = "card";
    card.innerHTML = `
        <div class="icono">${c.icono}</div>
        <h3>${c.nombre}</h3>
        <span class="nivel">${c.nivel}</span>
        <span class="duracion">⏱ ${c.duracion}</span>
    `;
    grid.appendChild(card);

    const opt = document.createElement("option");
    opt.value = c.nombre;
    opt.textContent = `${c.icono} ${c.nombre}`;
    selectCurso.appendChild(opt);
});

function mostrarFormulario() {
    document.getElementById("inscripcion").classList.remove("oculto");
    document.getElementById("inscripcion").scrollIntoView({ behavior: "smooth" });
}

function inscribir(event) {
    event.preventDefault();
    const nombre = document.getElementById("nombre").value.trim();
    const curso  = document.getElementById("curso").value;
    if (!nombre || !curso) return;

    const msg = document.getElementById("mensaje-confirmacion");
    msg.textContent = `¡Bienvenido/a, ${nombre}! Tu inscripción en "${curso}" fue confirmada. ✨`;
    msg.classList.remove("oculto");
    document.getElementById("form-inscripcion").reset();
}
