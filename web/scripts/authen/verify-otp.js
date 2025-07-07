
 const inputs = document.querySelectorAll('.otp-input');
 inputs.forEach((input, idx) => {
     input.addEventListener('input', function() {
         if (this.value.length === 1 && idx < inputs.length - 1) {
             inputs[idx + 1].focus();
         }
     });
     input.addEventListener('keydown', function(e) {
         if (e.key === 'Backspace' && this.value === '' && idx > 0) {
             inputs[idx - 1].focus();
         }
     });
 });

 document.getElementById('otpForm').addEventListener('submit', function(e) {
     let otp = '';
     inputs.forEach(input => otp += input.value);
     document.getElementById('otpFull').value = otp;
 });