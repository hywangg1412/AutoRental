<!-- Logout Confirmation Modal -->
<div class="modal fade" id="logoutConfirmModal" tabindex="-1" aria-labelledby="logoutConfirmModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header justify-content-center">
        <h5 class="modal-title w-100 text-center" id="logoutConfirmModalLabel">Confirm Logout</h5>
        <button type="button" class="btn-close position-absolute end-0 me-3" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body text-center fs-5">
        Are you sure you want to log out?
      </div>
      <div class="modal-footer justify-content-center border-0 pb-4">
        <button type="button" class="btn btn-secondary px-4 me-2" data-bs-dismiss="modal">Cancel</button>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger px-4" id="confirmLogoutBtn">Logout</a>
      </div>
    </div>
  </div>
</div>

<style>
#logoutConfirmModal .modal-content {
    border-radius: 18px;
    box-shadow: 0 8px 32px rgba(0,0,0,0.18);
}
#logoutConfirmModal .modal-title {
    font-weight: 700;
    font-size: 1.6rem;
    letter-spacing: 0.5px;
}
#logoutConfirmModal .modal-body {
    font-size: 1.15rem;
    color: #333;
    padding-top: 18px;
    padding-bottom: 18px;
}
#logoutConfirmModal .btn {
    font-size: 1rem;
    border-radius: 8px;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Tìm tất cả nút logout có id hoặc class logoutBtn
    var logoutBtns = document.querySelectorAll('#logoutBtn, .logoutBtn');
    logoutBtns.forEach(function(logoutBtn) {
        logoutBtn.addEventListener('click', function(e) {
            e.preventDefault();
            var modal = new bootstrap.Modal(document.getElementById('logoutConfirmModal'));
            modal.show();
        });
    });
});
</script>
