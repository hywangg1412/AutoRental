function moveIndicatorToActive() {
    const indicator = document.querySelector('.sidebar-indicator');
    const active = document.querySelector('.sidebar-menu .nav-link.active');
    if (indicator && active) {
        const rect = active.getBoundingClientRect();
        const sidebarRect = active.closest('.sidebar').getBoundingClientRect();
        indicator.style.top = (active.offsetTop) + "px";
        indicator.style.height = active.offsetHeight + "px";
    }
}

document.querySelectorAll('.sidebar-menu .nav-link').forEach(function(link) {
    link.addEventListener('click', function(e) {
        if (link.classList.contains('text-danger')) return;
        document.querySelectorAll('.sidebar-menu .nav-link').forEach(function(l) {
            l.classList.remove('active');
        });
        this.classList.add('active');
        moveIndicatorToActive();
    });
});

window.addEventListener('DOMContentLoaded', moveIndicatorToActive);
window.addEventListener('resize', moveIndicatorToActive);