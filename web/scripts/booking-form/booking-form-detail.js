/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

// Về vấn đề thời gian: HTML5 datetime-local input không thể giới hạn giờ cụ thể trong picker
// Chúng ta chỉ có thể validate sau khi người dùng chọn và hiển thị thông báo lỗi
// Đây là hạn chế của trình duyệt, không phải lỗi code

// Global variables
let carPriceData = {}
let days // Declare the days variable here

// Initialize when DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
  // Clear any stale data from previous sessions to prevent errors
  if (window.localStorage) {
    window.localStorage.clear()
  }
  initializeForm()
  loadCarPriceData()
  setupLicenseUpload()
  setupFormValidation()
  setupFlatpickrDateTimePickers() // Thêm cấu hình Flatpickr
  setupInsuranceHandlers()
})

// Initialize form
function initializeForm() {
  // Set minimum date to today
  const now = new Date()
  const today = now.toISOString().slice(0, 16)
  const startDateInput = document.getElementById("startDate")
  const endDateInput = document.getElementById("endDate")

  if (startDateInput) startDateInput.min = today
  if (endDateInput) endDateInput.min = today

  // Add event listeners for price calculation
  const rentalTypeSelect = document.getElementById("rentalType");
  if (rentalTypeSelect) {
    rentalTypeSelect.addEventListener("change", function() {
      calculatePrice();
      
      // Kiểm tra lại thời gian nếu đã chọn cả start date và end date
      const startDate = parseLocalDateTime("startDate");
      const endDate = parseLocalDateTime("endDate");
      
      if (startDate && endDate) {
        validateTimeRange(startDate, endDate);
      } else if (startDate) {
        // Nếu chỉ có start date, kiểm tra xem có gần giờ đóng cửa không
        const startHour = startDate.getHours();
        if (startHour >= 19) {
          const rentalType = this.value;
          if (rentalType === "hourly") {
            const startMinutes = startDate.getMinutes();
            const minutesUntilClosing = (22 - startHour) * 60 - startMinutes;
            const possibleRentalHours = Math.floor(minutesUntilClosing / 60);
            const possibleRentalMinutes = minutesUntilClosing % 60;
            
            if (minutesUntilClosing < 240) {
              showFixedAlert(
                `Warning: Your selected start time only allows for ${possibleRentalHours}h ${possibleRentalMinutes}m rental before closing (10:00 PM). Hourly rentals require minimum 4 hours. Please consider booking for tomorrow.`,
                "warning",
                false
              );
              showInputWarning('start-time', 'Too late for 4-hour rental');
            }
          } else if (rentalType === "daily" || rentalType === "monthly") {
            const warningMessage = rentalType === "daily" 
              ? "You're starting a daily rental late in the day. For optimal value, consider starting early morning tomorrow."
              : "You're starting a monthly rental late in the day. For optimal value, consider starting early morning tomorrow.";
            
            showFixedAlert(warningMessage, "info", false);
            showInputWarning('start-time', 'Consider booking tomorrow morning');
          }
        }
      }
    });
  }
  
  document.getElementById("startDate")?.addEventListener("change", calculatePrice);
  document.getElementById("endDate")?.addEventListener("change", calculatePrice);
  document.getElementById("additionalInsurance")?.addEventListener("change", calculatePrice);
  
  // Tự động mở startDatePicker khi trang được tải
  setTimeout(() => {
    // Nếu startDate chưa được chọn và startDatePicker đã được khởi tạo
    if (window.startDatePicker && !document.getElementById("startDate").value) {
      window.startDatePicker.open();
    }
  }, 800); // Đợi lâu hơn một chút để đảm bảo Flatpickr đã được khởi tạo
}

// Setup Flatpickr datetime pickers
function setupFlatpickrDateTimePickers() {
  const now = new Date();
  
  // Tính toán thời gian tối thiểu có thể chọn dựa trên giờ hiện tại
  const currentHour = now.getHours();
  const currentMinutes = now.getMinutes();
  
  // Tạo đối tượng minTime để lưu thời gian tối thiểu
  const minTime = new Date(now);
  
  // Quy tắc làm tròn thời gian:
  // 1. Nếu phút < 25, làm tròn lên 30 phút của giờ hiện tại
  // 2. Nếu 25 <= phút < 55, làm tròn lên giờ tiếp theo
  // 3. Nếu phút >= 55, làm tròn lên 30 phút của giờ tiếp theo
  
  if (currentMinutes < 25) {
    // Làm tròn lên 30 phút của giờ hiện tại
    minTime.setMinutes(30, 0, 0);
  } else if (currentMinutes < 55) {
    // Làm tròn lên giờ tiếp theo
    minTime.setHours(currentHour + 1, 0, 0, 0);
  } else {
    // Làm tròn lên 30 phút của giờ tiếp theo
    minTime.setHours(currentHour + 1, 30, 0, 0);
  }
  
  // Đảm bảo thời gian tối thiểu không sớm hơn thời gian hiện tại + 5 phút
  const bufferTime = new Date(now);
  bufferTime.setMinutes(bufferTime.getMinutes() + 5);
  
  if (minTime < bufferTime) {
    // Nếu thời gian làm tròn < thời gian hiện tại + 5 phút, đẩy lên 30 phút tiếp theo
    if (minTime.getMinutes() === 0) {
      minTime.setMinutes(30);
    } else {
      minTime.setHours(minTime.getHours() + 1, 0, 0, 0);
    }
  }
  
  // Nếu minTime < 7:00, đặt thành 7:00
  if (minTime.getHours() < 7) {
    minTime.setHours(7, 0, 0);
  }
  
  // Nếu minTime >= 22:00, đặt thành 7:00 ngày hôm sau
  if (minTime.getHours() >= 22) {
    minTime.setDate(minTime.getDate() + 1);
    minTime.setHours(7, 0, 0);
  }
  
  // Format minDate cho hiển thị
  const minDate = minTime.toISOString().split('T')[0];
  
  // Tạo defaultDate cho startDate (sử dụng minTime)
  const defaultStartDate = new Date(minTime);
  
  // Log thông tin để debug
  console.log("Current time:", now.toLocaleTimeString());
  console.log("Min time calculated:", minTime.toLocaleTimeString());
  console.log("Default start date:", defaultStartDate.toLocaleTimeString());
  
  // Cấu hình chung cho Flatpickr
  const commonConfig = {
    enableTime: true,
    dateFormat: "Y-m-d H:i",
    time_24hr: true,
    minuteIncrement: 30,
    allowInput: true,
    minTime: "07:00",
    maxTime: "22:00",
    minDate: minDate,
    disableMobile: true, // Tắt mobile picker mặc định để đảm bảo UI nhất quán
    locale: {
      firstDayOfWeek: 1,
      time_24hr: true
    },
    // Kiểm tra thời gian hợp lệ khi đóng picker
    onClose: function(selectedDates, dateStr, instance) {
      if (selectedDates.length > 0) {
        const date = selectedDates[0];
        const minutes = date.getMinutes();
        const hours = date.getHours();
        const now = new Date();
        
        // Kiểm tra giờ (7h-22h)
        if (hours < 7 || hours > 22) {
          showAlert("Please select a time between 7:00 AM and 10:00 PM", "error");

          // Tự động điều chỉnh thời gian
          if (hours < 7) {
            date.setHours(7);
            date.setMinutes(0);
          } else if (hours > 22) {
            // Nếu > 22h, chuyển sang 7h ngày hôm sau
            date.setDate(date.getDate() + 1);
            date.setHours(7);
            date.setMinutes(0);
          }
          instance.setDate(date);
          return false;
        }

        // Kiểm tra phút (chỉ 0 hoặc 30)
        if (minutes !== 0 && minutes !== 30) {
          showAlert("Please select time in 30-minute intervals (e.g., 7:00, 7:30, 8:00)", "error");
          
          // Tự động điều chỉnh phút
          if (minutes < 15) {
            date.setMinutes(0);
          } else if (minutes < 45) {
            date.setMinutes(30);
          } else {
            date.setMinutes(0);
            // Nếu giờ tiếp theo > 22h, chuyển sang 7h ngày hôm sau
            if (hours + 1 > 22) {
              date.setDate(date.getDate() + 1);
              date.setHours(7);
            } else {
              date.setHours(hours + 1);
            }
          }
          instance.setDate(date);
          return false;
        }
        
        // Kiểm tra nếu thời gian đã chọn < thời gian hiện tại + 5 phút
        const bufferTime = new Date(now);
        bufferTime.setMinutes(bufferTime.getMinutes() + 5);
        
        if (date < bufferTime && instance.element.id === "startDate") {
          const minTime = new Date(now);
          
          // Áp dụng quy tắc làm tròn thời gian
          if (now.getMinutes() < 25) {
            minTime.setMinutes(30, 0, 0);
          } else if (now.getMinutes() < 55) {
            minTime.setHours(now.getHours() + 1, 0, 0, 0);
          } else {
            minTime.setHours(now.getHours() + 1, 30, 0, 0);
          }
          
          // Đảm bảo thời gian tối thiểu không sớm hơn thời gian hiện tại + 5 phút
          if (minTime < bufferTime) {
            if (minTime.getMinutes() === 0) {
              minTime.setMinutes(30);
            } else {
              minTime.setHours(minTime.getHours() + 1, 0, 0, 0);
            }
          }
          
          // Nếu minTime < 7:00, đặt thành 7:00
          if (minTime.getHours() < 7) {
            minTime.setHours(7, 0, 0);
          }
          
          // Nếu minTime >= 22:00, đặt thành 7:00 ngày hôm sau
          if (minTime.getHours() >= 22) {
            minTime.setDate(minTime.getDate() + 1);
            minTime.setHours(7, 0, 0);
          }
          
          showAlert(`Pickup time must be at least ${minTime.getHours()}:${minTime.getMinutes() === 0 ? '00' : minTime.getMinutes()} or later.`, "error");
          instance.setDate(minTime);
          return false;
        }
        
        // Validate thời gian bắt đầu và kết thúc
        validateDateRange();
      }
    }
  };
  
  // Cấu hình cho startDate
  const startDatePicker = flatpickr("#startDate", {
    ...commonConfig,
    minDate: minDate,
    defaultDate: defaultStartDate, // Sử dụng thời gian hiện tại làm tròn lên 30 phút
    onChange: function(selectedDates, dateStr) {
      // Cập nhật minDate cho endDate khi startDate thay đổi
      if (selectedDates.length > 0) {
        // Đảm bảo thời gian bắt đầu không trong quá khứ
        const startDate = selectedDates[0];
        const now = new Date();
        
        // Tạo thời gian tối thiểu dựa trên giờ hiện tại
        const minTime = new Date(now);
        
        // Áp dụng quy tắc làm tròn thời gian
        if (now.getMinutes() < 25) {
          minTime.setMinutes(30, 0, 0);
        } else if (now.getMinutes() < 55) {
          minTime.setHours(now.getHours() + 1, 0, 0, 0);
        } else {
          minTime.setHours(now.getHours() + 1, 30, 0, 0);
        }
        
        // Đảm bảo thời gian tối thiểu không sớm hơn thời gian hiện tại + 5 phút
        const bufferTime = new Date(now);
        bufferTime.setMinutes(bufferTime.getMinutes() + 5);
        
        if (minTime < bufferTime) {
          if (minTime.getMinutes() === 0) {
            minTime.setMinutes(30);
          } else {
            minTime.setHours(minTime.getHours() + 1, 0, 0, 0);
          }
        }
        
        // Nếu minTime < 7:00, đặt thành 7:00
        if (minTime.getHours() < 7) {
          minTime.setHours(7, 0, 0);
        }
        
        // Nếu minTime >= 22:00, đặt thành 7:00 ngày hôm sau
        if (minTime.getHours() >= 22) {
          minTime.setDate(minTime.getDate() + 1);
          minTime.setHours(7, 0, 0);
        }
        
        // Kiểm tra nếu thời gian đã chọn < thời gian tối thiểu
        if (startDate < minTime) {
          showFixedAlert(`Pickup time must be at least ${minTime.getHours()}:${minTime.getMinutes() === 0 ? '00' : minTime.getMinutes()} or later.`, "error");
          showInputWarning('start-time', 'Time already passed');
          
          // Tự động điều chỉnh thành thời gian tối thiểu
          setTimeout(() => {
            startDatePicker.setDate(minTime);
          }, 1500);
          return;
        }
        
        // Cập nhật minDate cho endDate
        const minEndDate = new Date(startDate);
        // Thêm 4 giờ cho thuê theo giờ
        minEndDate.setHours(minEndDate.getHours() + 4);
        
        // Nếu minEndDate > 22:00, đặt thành 7:00 ngày hôm sau
        if (minEndDate.getHours() >= 22) {
          minEndDate.setDate(minEndDate.getDate() + 1);
          minEndDate.setHours(7, 0, 0);
        }
        
        endDatePicker.set('minDate', minEndDate);
        endDatePicker.set('defaultDate', minEndDate);
        
        // Xóa cảnh báo nếu thời gian hợp lệ
        hideInputWarning('start-time');
        
        // Kiểm tra thời gian bắt đầu có gần giờ đóng cửa không
        const startHour = startDate.getHours();
        const startMinutes = startDate.getMinutes();
        const rentalType = document.getElementById("rentalType")?.value;
        
        // Tính số phút còn lại đến 22:00
        const minutesUntilClosing = (22 - startHour) * 60 - startMinutes;
        
        // Nếu thời gian bắt đầu là sau 19:00 và loại thuê là theo giờ
        if (startHour >= 19 && rentalType === "hourly") {
          const possibleRentalHours = Math.floor(minutesUntilClosing / 60);
          const possibleRentalMinutes = minutesUntilClosing % 60;
          
          if (minutesUntilClosing < 240) { // 4 giờ = 240 phút
            showFixedAlert(
              `Warning: Starting rental at ${startHour}:${startMinutes < 10 ? '0' + startMinutes : startMinutes} only allows for ${possibleRentalHours}h ${possibleRentalMinutes}m rental time before closing (10:00 PM). Hourly rentals require minimum 4 hours. Please consider booking for tomorrow.`,
              "warning",
              false
            );
            showInputWarning('start-time', 'Too late for 4-hour rental');
          } else {
            showFixedAlert(
              `You're booking close to closing time (10:00 PM). You have ${possibleRentalHours}h ${possibleRentalMinutes}m available before closing.`,
              "info",
              false
            );
          }
        } else if (startHour >= 19 && (rentalType === "daily" || rentalType === "monthly")) {
          // Thông báo cho thuê theo ngày hoặc tháng vào buổi tối
          const warningMessage = rentalType === "daily" 
            ? "You're starting a daily rental late in the day. For optimal value, consider starting early morning tomorrow instead."
            : "You're starting a monthly rental late in the day. For optimal value, consider starting early morning tomorrow instead.";
          
          showFixedAlert(warningMessage, "info", false);
          showInputWarning('start-time', 'Consider booking tomorrow morning');
        }
        
        // Tự động tính toán giá sau khi chọn
        calculatePrice();
      }
    }
  });
  
  // Cấu hình cho endDate
  const endDatePicker = flatpickr("#endDate", {
    ...commonConfig,
    minDate: minDate,
    defaultDate: null,
    onChange: function(selectedDates, dateStr) {
      if (selectedDates.length > 0) {
        // Validate ngay khi người dùng chọn end date
        const startDate = parseLocalDateTime("startDate");
        const endDate = selectedDates[0];
        
        if (startDate) {
          // Xóa cảnh báo trước khi kiểm tra lại
          hideInputWarning('end-time');
          
          // Kiểm tra end date có sau start date không
          if (endDate <= startDate) {
            showFixedAlert("End date must be after start date", "error", false);
            showInputWarning('end-time', 'Must be after start date');
            
            // Tự động điều chỉnh end date thành start date + 4 giờ
            setTimeout(() => {
              const adjustedEndDate = new Date(startDate);
              adjustedEndDate.setHours(adjustedEndDate.getHours() + 4);
              
              // Nếu vượt quá 22:00, đặt thành 7:00 sáng hôm sau
              if (adjustedEndDate.getHours() >= 22) {
                adjustedEndDate.setDate(adjustedEndDate.getDate() + 1);
                adjustedEndDate.setHours(7, 0, 0);
              }
              
              endDatePicker.setDate(adjustedEndDate);
            }, 1500);
            return;
          }
          
          validateTimeRange(startDate, endDate);
        } else {
          showInputWarning('start-time', 'Please select start date first');
          
          // Tự động focus vào start date
          setTimeout(() => {
            document.getElementById("startDate").focus();
          }, 500);
          return;
        }
        
        // Tự động tính toán giá sau khi chọn
        calculatePrice();
      }
    }
  });

  // Lưu reference để sử dụng sau này nếu cần
  window.startDatePicker = startDatePicker;
  window.endDatePicker = endDatePicker;
  
  // Tự động mở startDatePicker khi trang được tải
  setTimeout(() => {
    // Nếu startDate chưa được chọn, tự động mở picker
    if (!document.getElementById("startDate").value) {
      startDatePicker.open();
    }
  }, 500);
}

// Hàm kiểm tra khoảng thời gian
function validateTimeRange(startDate, endDate) {
    // Kiểm tra nếu end date <= start date
    if (endDate <= startDate) {
      showFixedAlert("End date must be after start time", "error", false);
      showInputWarning('end-time', 'Must be after start time');
      return false;
    }
    
    const timeDiff = endDate.getTime() - startDate.getTime();
    const hoursDiff = timeDiff / (1000 * 60 * 60);
    const daysDiff = hoursDiff / 24;
    let rentalType = document.getElementById("rentalType")?.value;
    const rentalTypeSelect = document.getElementById("rentalType");
    
    // Kiểm tra thời gian bắt đầu và kết thúc gần giờ nghỉ
    const startHour = startDate.getHours();
    const startMinutes = startDate.getMinutes();
    const endHour = endDate.getHours();
    const endMinutes = endDate.getMinutes();
    
    // Kiểm tra nếu thời gian thuê ngắn và trong cùng ngày
    const sameDay = startDate.getDate() === endDate.getDate() && 
                    startDate.getMonth() === endDate.getMonth() && 
                    startDate.getFullYear() === endDate.getFullYear();
    
    // Kiểm tra nếu cả start date và end date đều gần giờ nghỉ
    const nearClosingTime = startHour >= 19 && endHour >= 21;
    
    // QUY TẮC MỚI: Tự động điều chỉnh rental type dựa trên thời gian thuê
    let rentalTypeChanged = false;
    let rentalTypeMessage = "";
    
    // 1. Nếu thời gian thuê < 24 giờ, luôn chuyển sang hourly
    if (hoursDiff < 24 && rentalType !== "hourly") {
      rentalType = "hourly";
      rentalTypeChanged = true;
      rentalTypeMessage = "Your rental has been automatically changed to hourly rental because the duration is less than 24 hours.";
    } 
    // 2. Nếu thời gian thuê >= 24 giờ và < 30 ngày, luôn chuyển sang daily
    else if (hoursDiff >= 24 && daysDiff < 30 && rentalType !== "daily") {
      rentalType = "daily";
      rentalTypeChanged = true;
      rentalTypeMessage = daysDiff < 1 
        ? "Your rental has been automatically changed to daily rental because the duration is 24 hours or more."
        : `Your rental has been automatically changed to daily rental because the duration is ${Math.ceil(daysDiff)} days.`;
    }
    // 3. Nếu thời gian thuê >= 30 ngày, luôn chuyển sang monthly
    else if (daysDiff >= 30 && rentalType !== "monthly") {
      rentalType = "monthly";
      rentalTypeChanged = true;
      rentalTypeMessage = `Your rental has been automatically changed to monthly rental because the duration is ${Math.floor(daysDiff)} days (30+ days).`;
    }
    
    // Cập nhật rental type nếu có thay đổi
    if (rentalTypeChanged && rentalTypeSelect) {
      rentalTypeSelect.value = rentalType;
      showFixedAlert(rentalTypeMessage, "info", false);
      
      // Đặt timeout để đảm bảo thông báo được hiển thị trước khi tính toán giá
    setTimeout(() => {
        calculatePrice();
      }, 100);
    }
    
    // Kiểm tra thời gian bắt đầu gần giờ nghỉ
    if (startHour >= 19) {
      let warningMessage = "";
      
      // Kiểm tra xem thời gian kết thúc có phải là ngày hôm sau không
      const isNextDay = endDate.getDate() > startDate.getDate() || 
                        endDate.getMonth() > startDate.getMonth() || 
                        endDate.getFullYear() > startDate.getFullYear();
      
      // Chỉ hiển thị cảnh báo nếu không phải ngày hôm sau
      if (!isNextDay) {
        if (rentalType === "hourly") {
          // Tính số phút còn lại đến 22:00
          const minutesUntilClosing = (22 - startHour) * 60 - startMinutes;
          const possibleRentalHours = Math.floor(minutesUntilClosing / 60);
          const possibleRentalMinutes = minutesUntilClosing % 60;
          
          // Kiểm tra xem thời gian kết thúc có phải là 7:00 sáng ngày hôm sau không
          const isNextDayMorning = endDate.getDate() > startDate.getDate() && endHour === 7 && endMinutes === 0;
          
          // Chỉ hiển thị cảnh báo nếu thời gian thuê có thể < 4 giờ trước khi đóng cửa và chưa điều chỉnh sang ngày hôm sau
          if (minutesUntilClosing < 240 && !isNextDayMorning) {
            warningMessage = `Warning: Starting rental at ${startHour}:${startMinutes < 10 ? '0' + startMinutes : startMinutes} only allows for ${possibleRentalHours}h ${possibleRentalMinutes}m rental time before closing (10:00 PM). Hourly rentals require minimum 4 hours. Please consider booking for tomorrow.`;
          }
        } else if (rentalType === "daily" && startHour >= 20) {
          warningMessage = "You're starting a daily rental late in the day. For optimal value, consider starting early morning tomorrow instead.";
        } else if (rentalType === "monthly" && startHour >= 20) {
          warningMessage = "You're starting a monthly rental late in the day. For optimal value, consider starting early morning tomorrow instead.";
        }
      }
      
      if (warningMessage) {
        showFixedAlert(warningMessage, "warning", false);
        showInputWarning('start-time', 'Close to closing time');
      } else {
        hideInputWarning('start-time');
      }
    }
    
    // Kiểm tra thời gian kết thúc vượt quá giờ nghỉ
    if (endHour > 22 || (endHour === 22 && endMinutes > 0)) {
      if (rentalType === "hourly") {
        showFixedAlert(
          "End time exceeds our operating hours (10:00 PM). Please adjust to an earlier time or book for the next day.",
          "error",
          false
        );
        showInputWarning('end-time', 'Exceeds operating hours (10:00 PM)');
        return false;
      } else {
        // Đối với thuê theo ngày hoặc tháng, chỉ cảnh báo
        showFixedAlert(
          "Your rental will end after our operating hours (10:00 PM). You'll need to return the vehicle before 10:00 PM or the next morning after 7:00 AM.",
          "warning",
          false
        );
        showInputWarning('end-time', 'After operating hours - special return required');
      }
    }
    
    // Kiểm tra tùy theo loại thuê
    if (rentalType === "hourly") {
      // Kiểm tra nếu thời gian thuê < 4 giờ
      if (hoursDiff < 4) {
        // Kiểm tra xem thời gian kết thúc có phải là ngày hôm sau không
        const isNextDay = endDate.getDate() > startDate.getDate() || 
                          endDate.getMonth() > startDate.getMonth() || 
                          endDate.getFullYear() > startDate.getFullYear();
        
        // Chỉ hiển thị cảnh báo và điều chỉnh thời gian nếu không phải ngày hôm sau
        if (!isNextDay) {
          showFixedAlert("Minimum rental duration for hourly rentals is 4 hours. The end time will be adjusted automatically.", "warning", false);
          showInputWarning('end-time', 'Minimum 4 hours required');
          
          // Tự động điều chỉnh thời gian kết thúc
          let adjustedEndDate;
          
          // Nếu thời gian bắt đầu gần giờ đóng cửa (sau 18:00) và không đủ 4 giờ trước 22:00
          if (startHour >= 18 && (startHour * 60 + startMinutes + 240) > (22 * 60)) {
            // Chuyển sang 7:00 sáng hôm sau
            adjustedEndDate = new Date(startDate);
            adjustedEndDate.setDate(adjustedEndDate.getDate() + 1);
            adjustedEndDate.setHours(7, 0, 0);
            
            showFixedAlert(
              "Since your start time is close to closing hours and requires minimum 4 hours rental, we've adjusted your end time to 7:00 AM tomorrow.",
              "warning",
              false
            );
          } else {
            // Điều chỉnh thành đủ 4 giờ từ thời điểm bắt đầu
            adjustedEndDate = new Date(startDate.getTime() + (4 * 60 * 60 * 1000));
            
            // Kiểm tra nếu thời gian kết thúc điều chỉnh vượt quá 22:00
            if (adjustedEndDate.getHours() > 22 || (adjustedEndDate.getHours() === 22 && adjustedEndDate.getMinutes() > 0)) {
              // Chuyển sang 7:00 sáng hôm sau
              adjustedEndDate = new Date(startDate);
              adjustedEndDate.setDate(adjustedEndDate.getDate() + 1);
              adjustedEndDate.setHours(7, 0, 0);
            }
          }
          
          // Cập nhật thời gian kết thúc sau một khoảng thời gian ngắn để người dùng thấy thông báo trước
          setTimeout(() => {
            endDatePicker.setDate(adjustedEndDate);
            hideInputWarning('end-time');
          }, 2000);
        } // Đóng if (!isNextDay)
      } else if (hoursDiff >= 24) {
        // QUY TẮC MỚI: Nếu thuê theo giờ nhưng thời gian ≥ 24 giờ, đề xuất chuyển sang thuê theo ngày
        showFixedAlert("For rentals of 24 hours or more, we recommend switching to daily rental type for better pricing.", "info", false);
        showInputWarning('end-time', 'Consider daily rental for ≥24 hours');
      } else {
        hideInputWarning('end-time');
      }
    } else if (rentalType === "daily") {
      // Kiểm tra nếu thời gian thuê ngắn và kết thúc trong cùng ngày
      if (sameDay && startHour >= 16) {
        showFixedAlert(
          "You're booking a daily rental that starts and ends on the same day, late in the day. For better value, consider starting early tomorrow morning.",
          "info",
          false
        );
      }
    } else if (rentalType === "monthly") {
      // Kiểm tra nếu thời gian bắt đầu là cuối ngày
      if (startHour >= 16) {
        showFixedAlert(
          "You're starting a monthly rental late in the day. For optimal value, consider starting early morning tomorrow instead.",
          "info",
          false
        );
      }
    }
    
    return true;
  }

  // Lưu reference để sử dụng sau này nếu cần
  window.startDatePicker = startDatePicker;
  window.endDatePicker = endDatePicker;


// Hàm validate thời gian bắt đầu và kết thúc
function validateDateRange() {
  const startDate = parseLocalDateTime("startDate");
  const endDate = parseLocalDateTime("endDate");
  
  if (startDate && endDate) {
    // Kiểm tra nếu endDate <= startDate
    if (endDate <= startDate) {
      showAlert("End date must be after start date.", "error");
      return false;
    }
    
    // Kiểm tra thời gian thuê theo giờ
    const rentalType = document.getElementById("rentalType")?.value;
    if (rentalType === "hourly") {
      const timeDiff = endDate.getTime() - startDate.getTime();
      const hoursDiff = timeDiff / (1000 * 60 * 60);
      
      // Kiểm tra nếu thời gian thuê < 4 giờ
      if (hoursDiff < 4) {
        showAlert("Minimum rental duration for hourly rentals is 4 hours.", "warning");
        
        // Tự động điều chỉnh thời gian kết thúc
        const adjustedEndDate = new Date(startDate.getTime() + (4 * 60 * 60 * 1000));
        
        // Kiểm tra nếu thời gian kết thúc điều chỉnh vượt quá 22:00
        if (adjustedEndDate.getHours() > 22 || (adjustedEndDate.getHours() === 22 && adjustedEndDate.getMinutes() > 0)) {
          showAlert("The rental period would extend beyond our operating hours (10:00 PM). Please consider booking for tomorrow or choosing a different start time.", "warning");
        } else {
          // Cập nhật thời gian kết thúc
          window.endDatePicker.setDate(adjustedEndDate);
        }
        return false;
      }
      
      // Kiểm tra nếu thời gian thuê > 24 giờ
      if (hoursDiff > 24) {
        showAlert("For rentals over 24 hours, we recommend choosing daily rental type for better pricing.", "info");
      }
    }
  }
  
  return true;
}

// Expose validateDateRange globally
window.validateDateRange = validateDateRange;



// Setup insurance handlers
function setupInsuranceHandlers() {
  const additionalInsuranceCheckbox = document.getElementById("additionalInsurance")
  if (additionalInsuranceCheckbox) {
    additionalInsuranceCheckbox.addEventListener("change", function () {
      const insuranceRow = document.getElementById("additionalInsuranceRow")
      if (insuranceRow) {
        insuranceRow.style.display = this.checked ? "flex" : "none"
      }
      calculatePrice()
    })
  }
}

// Show insurance details modal
function showInsuranceDetails(type) {
  const modal = document.getElementById("insuranceModal")
  const modalTitle = document.getElementById("modalTitle")
  const modalBody = document.getElementById("modalBody")

  if (type === "basic") {
    modalTitle.textContent = "Chi tiết Bảo hiểm Thuê xe"
    modalBody.innerHTML = `
            <div class="insurance-details">
                <div class="insurance-intro">
                    <p>Với nhiều năm kinh nghiệm trong lĩnh vực cho thuê xe, chúng tôi hiểu rằng các rủi ro va chạm, cháy, nổ và lũ lụt có thể gây thiệt hại đáng kể (vượt quá khả năng chi trả) trong thời gian thuê.</p>
                    <p>Hầu hết các rủi ro phát sinh trong quá trình thuê xe tự lái không được bảo hiểm xe hàng năm bao gồm (còn gọi là bảo hiểm 2 chiều).</p>
                </div>

                <div class="coverage-section">
                    <h4><i class="fas fa-shield-alt"></i> Chi tiết Bảo hiểm</h4>
                    <p>Trong thời gian thuê, nếu xảy ra va chạm bất ngờ gây hư hỏng xe, người thuê chỉ phải bồi thường tối đa <strong>2.000.000 VNĐ</strong> cho việc sửa chữa xe (số tiền khấu trừ). Công ty bảo hiểm sẽ chi trả chi phí vượt quá khoản khấu trừ.</p>
                    
                    <div class="damage-table">
                        <div class="table-header">
                            <div>Thiệt hại xe</div>
                            <div>Khách hàng thanh toán</div>
                            <div>Bảo hiểm thanh toán</div>
                        </div>
                        <div class="table-row">
                            <div>≤ 2 triệu VNĐ</div>
                            <div>≤ 2 triệu VNĐ</div>
                            <div>0 VNĐ</div>
                        </div>
                        <div class="table-row">
                            <div>> 2 triệu VNĐ</div>
                            <div>2 triệu VNĐ</div>
                            <div>Số tiền còn lại</div>
                        </div>
                    </div>
                    
                    <div class="example-box">
                        <h5><i class="fas fa-calculator"></i> Ví dụ:</h5>
                        <p>Nếu thiệt hại xe là 300.000.000 VNĐ:</p>
                        <ul>
                            <li>Khách hàng trả: 2.000.000 VNĐ</li>
                            <li>Bảo hiểm chi trả: 298.000.000 VNĐ</li>
                        </ul>
                    </div>
                </div>

                <div class="terms-section">
                    <h4><i class="fas fa-file-contract"></i> Điều khoản Bảo hiểm</h4>
                    <ul class="terms-list">
                        <li><strong>Bảo hiểm Vật chất Xe:</strong> Va chạm, cháy, nổ</li>
                        <li><strong>Cứu hộ Miễn phí:</strong> Lên đến 70km mỗi sự cố</li>
                        <li><strong>Bảo hiểm Lũ lụt:</strong> Khấu trừ 20% số tiền bảo hiểm, tối thiểu 3 triệu VNĐ</li>
                        <li><strong>Khấu trừ:</strong> 2.000.000 VNĐ mỗi sự cố</li>
                    </ul>
                    
                    <div class="deductible-note">
                        <h5>Giải thích về Khấu trừ:</h5>
                        <p>Đối với bất kỳ sự cố bất ngờ nào trong phạm vi bảo hiểm, số tiền tối đa người thuê phải trả là 2 triệu VNĐ, không bao gồm:</p>
                        <ul>
                            <li>Giảm bồi thường/phạt theo quy định của công ty bảo hiểm</li>
                            <li>Thiệt hại do xe không sử dụng được trong thời gian sửa chữa</li>
                            <li>Các lý do chủ quan khác ngoài phạm vi bảo hiểm</li>
                        </ul>
                    </div>
                </div>

                <div class="process-section">
                    <h4><i class="fas fa-clipboard-list"></i> Quy trình Yêu cầu Bồi thường</h4>
                    <ol class="process-list">
                        <li>Giữ nguyên hiện trường & chụp ảnh xe bị hư hỏng</li>
                        <li>Gọi trung tâm bảo hiểm: MIC (1900 55 88 91) hoặc VNI (1900 96 96 90)</li>
                        <li>Cung cấp số hợp đồng bảo hiểm và làm theo hướng dẫn từ đường dây nóng</li>
                        <li>Nhân viên giám định liên hệ với người thuê để hướng dẫn và xác minh</li>
                        <li>Giám định viên và chủ xe/người thuê đưa xe đến gara để đánh giá thiệt hại</li>
                        <li>Trung tâm bảo hiểm cấp báo cáo đánh giá thiệt hại</li>
                        <li>Gara tiến hành sửa chữa theo báo giá</li>
                    </ol>
                </div>

                <div class="important-note">
                    <i class="fas fa-exclamation-triangle"></i>
                    <strong>Quan trọng:</strong> Khách hàng phải tuân theo quy trình xử lý sự cố đầy đủ được nêu ở trên.
                </div>
            </div>
        `
  } else if (type === "additional") {
    modalTitle.textContent = "Chi tiết Bảo hiểm Tai nạn Cá nhân"
    modalBody.innerHTML = `
            <div class="insurance-details">
                <div class="insurance-intro">
                    <p>Trong thời gian thuê, người lái xe và hành khách được bảo hiểm cho thương tích cơ thể từ các sự cố bất ngờ khi tham gia giao thông, với quyền lợi bảo hiểm lên đến <strong>300.000.000 VNĐ mỗi người mỗi chuyến</strong>.</p>
                </div>

                <div class="coverage-section">
                    <h4><i class="fas fa-user-shield"></i> Chi tiết Bảo hiểm</h4>
                    <div class="coverage-highlights">
                        <div class="highlight-item">
                            <i class="fas fa-heart"></i>
                            <div>
                                <h5>Bảo hiểm Thương tích Cá nhân</h5>
                                <p>Lên đến 300.000.000 VNĐ mỗi người</p>
                            </div>
                        </div>
                        <div class="highlight-item">
                            <i class="fas fa-hospital"></i>
                            <div>
                                <h5>Hoàn trả Chi phí Y tế</h5>
                                <p>Bảo hiểm toàn bộ chi phí điều trị</p>
                            </div>
                        </div>
                        <div class="highlight-item">
                            <i class="fas fa-wheelchair"></i>
                            <div>
                                <h5>Bồi thường Thương tật</h5>
                                <p>Quyền lợi thương tật liên quan đến tai nạn</p>
                            </div>
                        </div>
                        <div class="highlight-item">
                            <i class="fas fa-ambulance"></i>
                            <div>
                                <h5>Sơ tán Y tế Khẩn cấp</h5>
                                <p>Bảo hiểm vận chuyển khẩn cấp</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="terms-section">
                    <h4><i class="fas fa-file-contract"></i> Điều khoản Bảo hiểm</h4>
                    <ul class="terms-list">
                        <li><strong>Phạm vi Bảo hiểm:</strong> Thương tích cơ thể do tai nạn giao thông, không bao gồm các lý do chủ quan ngoài phạm vi bảo hiểm</li>
                        <li><strong>Cơ sở Y tế:</strong> Bất kỳ cơ sở chăm sóc sức khỏe nào trên toàn quốc</li>
                        <li><strong>Không Khấu trừ:</strong> Bảo hiểm toàn bộ chi phí y tế</li>
                        <li><strong>Hỗ trợ 24/7:</strong> Đường dây nóng hỗ trợ yêu cầu bồi thường 24/7</li>
                    </ul>
                </div>

                <div class="process-section">
                    <h4><i class="fas fa-clipboard-list"></i> Quy trình Yêu cầu Bồi thường</h4>
                    <ol class="process-list">
                        <li><strong>Ứng phó Khẩn cấp:</strong> Sơ cứu hoặc gọi dịch vụ cấp cứu (115)</li>
                        <li><strong>Báo cáo Sự cố:</strong> Liên hệ với Bảo hiểm VNI (1900 96 96 90) và làm theo hướng dẫn</li>
                        <li><strong>Nộp Hồ sơ:</strong>
                            <ul class="document-list">
                                <li>Giấy tờ xe (đăng ký, đăng kiểm), giấy phép lái xe, giấy chứng nhận bảo hiểm (bản sao)</li>
                                <li>Mẫu yêu cầu bồi thường bảo hiểm</li>
                                <li>Đơn thuốc, giấy ra viện, hoặc xác nhận thương tích (bản sao)</li>
                                <li>Hồ sơ y tế: hóa đơn, chỉ định xét nghiệm, kết quả xét nghiệm (bản sao)</li>
                                <li>Các tài liệu khác theo yêu cầu của công ty bảo hiểm</li>
                            </ul>
                        </li>
                    </ol>
                </div>

                <div class="benefits-section">
                    <h4><i class="fas fa-star"></i> Quyền lợi Chính</h4>
                    <div class="benefits-grid">
                        <div class="benefit-item">
                            <i class="fas fa-users"></i>
                            <span>Bảo hiểm cho tất cả hành khách trên xe</span>
                        </div>
                        <div class="benefit-item">
                            <i class="fas fa-money-bill-wave"></i>
                            <span>Không khấu trừ cho chi phí y tế</span>
                        </div>
                        <div class="benefit-item">
                            <i class="fas fa-phone-alt"></i>
                            <span>Đường dây nóng hỗ trợ yêu cầu bồi thường 24/7</span>
                        </div>
                        <div class="benefit-item">
                            <i class="fas fa-clock"></i>
                            <span>Xử lý yêu cầu bồi thường nhanh chóng</span>
                        </div>
                    </div>
                </div>

                <div class="pricing-note">
                    <i class="fas fa-tag"></i>
                    <strong>Chi phí:</strong> Chỉ 30.000-50.000 VNĐ mỗi ngày cho sự an tâm toàn diện và bảo vệ nâng cao.
                </div>
            </div>
        `
  }

  modal.style.display = "flex"
}

// Close insurance modal
function closeInsuranceModal() {
  const modal = document.getElementById("insuranceModal")
  modal.style.display = "none"
}

// Close modal when clicking outside
window.addEventListener("click", (event) => {
  const modal = document.getElementById("insuranceModal")
  if (event.target === modal) {
    closeInsuranceModal()
  }
})

// Load car price data from HTML
function loadCarPriceData() {
  const priceDataElement = document.getElementById("carPriceData")
  if (priceDataElement) {
    carPriceData = {
      hourly: Number.parseFloat(priceDataElement.dataset.hourly) || 0,
      daily: Number.parseFloat(priceDataElement.dataset.daily) || 0,
      monthly: Number.parseFloat(priceDataElement.dataset.monthly) || 0,
    }
  }
}

// Setup license upload functionality
function setupLicenseUpload() {
  const licenseImageInput = document.getElementById("licenseImageInput")
  if (licenseImageInput) {
    licenseImageInput.addEventListener("change", handleLicenseImageUpload)
  }
}

// Handle license image upload
function handleLicenseImageUpload(e) {
  const file = e.target.files[0]
  const licenseImagePreview = document.getElementById("licenseImagePreview")

  if (file && licenseImagePreview) {
    // Validate file type
    const allowedTypes = ["image/jpeg", "image/jpg", "image/png", "image/gif"]
    if (!allowedTypes.includes(file.type)) {
      showAlert("Please select a valid image file (JPG, PNG, GIF)", "error")
      return
    }

    // Validate file size (5MB limit)
    const maxSize = 5 * 1024 * 1024 // 5MB in bytes
    if (file.size > maxSize) {
      showAlert("File size must be less than 5MB", "error")
      return
    }

    // Create preview
    const reader = new FileReader()
    reader.onload = (e) => {
      licenseImagePreview.innerHTML = `
                <img id="previewImg" src="${e.target.result}" alt="License Preview">
                <button type="button" class="remove-image" onclick="removeLicenseImage()">
                    <i class="fas fa-times"></i>
                </button>
            `
      licenseImagePreview.style.display = "block"
    }
    reader.readAsDataURL(file)

    showAlert("License image uploaded successfully", "success")
  }
}

// Remove license image
function removeLicenseImage() {
  const licenseImageInput = document.getElementById("licenseImageInput")
  const licenseImagePreview = document.getElementById("licenseImagePreview")

  if (licenseImageInput) licenseImageInput.value = ""
  if (licenseImagePreview) {
    licenseImagePreview.style.display = "none"
    licenseImagePreview.innerHTML = ""
  }
}

// Setup form validation
function setupFormValidation() {
  const bookingForm = document.getElementById("bookingForm")
  if (bookingForm) {
    // Remove any existing event listeners
    bookingForm.removeEventListener("submit", validateAndSubmitForm)

    // Add new event listener
    bookingForm.addEventListener("submit", (e) => {
      validateAndSubmitForm(e)
    })
  }
}

// Validate and submit form
function validateAndSubmitForm(e) {
  e.preventDefault()
  
  if (!validateForm()) {
    showAlert("Please fix the errors before submitting.", "error")
    return false
  }

  // Đảm bảo rentalType được gửi đúng định dạng (hourly, daily, monthly)
  const rentalTypeSelect = document.getElementById("rentalType");
  const hiddenRentalType = document.getElementById("hiddenRentalType");
  
  if (rentalTypeSelect && hiddenRentalType) {
    const validRentalTypes = ["hourly", "daily", "monthly"];
    const selectedType = rentalTypeSelect.value.toLowerCase();
    
    if (validRentalTypes.includes(selectedType)) {
      hiddenRentalType.value = selectedType;
    } else {
      showAlert("Invalid rental type. Please select hourly, daily, or monthly.", "error");
      return false;
    }
  }

  // Show loading state
  const submitBtn = document.querySelector('button[type="submit"]')
  if (submitBtn) {
    const originalText = submitBtn.innerHTML
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...'
    submitBtn.disabled = true
  }

  // Đảm bảo form được submit
  document.getElementById("bookingForm").submit();
  
  return true
}

// Create Date object accurately according to local time (no timezone offset)
function parseLocalDateTime(inputId) {
  const input = document.getElementById(inputId)?.value
  if (!input) return null

  // Xử lý cả định dạng của Flatpickr (YYYY-MM-DD HH:MM) và định dạng HTML5 (YYYY-MM-DDTHH:MM)
  let datePart, timePart;
  
  if (input.includes("T")) {
    // Định dạng HTML5 datetime-local: YYYY-MM-DDTHH:MM
    [datePart, timePart] = input.split("T")
  } else {
    // Định dạng Flatpickr: YYYY-MM-DD HH:MM
    const parts = input.split(" ")
    datePart = parts[0]
    timePart = parts[1]
  }
  
  if (!datePart || !timePart) return null
  
  const [year, month, day] = datePart.split("-").map(Number)
  const [hour, minute] = timePart.split(":").map(Number)

  // Return Date object according to local time, NO UTC offset
  return new Date(year, month - 1, day, hour, minute)
}

// Calculate price
function calculatePrice() {
  const rentalTypeSelect = document.getElementById("rentalType");
  let rentalType = rentalTypeSelect?.value;
  const startDate = parseLocalDateTime("startDate");
  const endDate = parseLocalDateTime("endDate");
  const additionalInsurance = document.getElementById("additionalInsurance")?.checked || false;

  if (!rentalType || !startDate?.getTime() || !endDate?.getTime() || startDate >= endDate) {
    updatePriceDisplay(0, 0, "0", 0, 0, 0, additionalInsurance);
    return;
  }

  const timeDiff = endDate.getTime() - startDate.getTime();
  const totalHours = timeDiff / (1000 * 60 * 60);
  const totalDays = totalHours / 24;
  
  // QUY TẮC MỚI: Tự động điều chỉnh rental type dựa trên thời gian thuê
  let rentalTypeChanged = false;
  
  // 1. Nếu thời gian thuê < 24 giờ, luôn chuyển sang hourly
  if (totalHours < 24 && rentalType !== "hourly") {
    rentalType = "hourly";
    rentalTypeChanged = true;
    
    // Cập nhật UI nếu cần
    if (rentalTypeSelect) {
      rentalTypeSelect.value = "hourly";
    }
  } 
  // 2. Nếu thời gian thuê >= 24 giờ và < 30 ngày, luôn chuyển sang daily
  else if (totalHours >= 24 && totalDays < 30 && rentalType !== "daily") {
    rentalType = "daily";
    rentalTypeChanged = true;
    
    // Cập nhật UI nếu cần
    if (rentalTypeSelect) {
      rentalTypeSelect.value = "daily";
    }
  }
  // 3. Nếu thời gian thuê >= 30 ngày, luôn chuyển sang monthly
  else if (totalDays >= 30 && rentalType !== "monthly") {
    rentalType = "monthly";
    rentalTypeChanged = true;
    
    // Cập nhật UI nếu cần
    if (rentalTypeSelect) {
      rentalTypeSelect.value = "monthly";
    }
  }

  let duration = 0,
    unitPrice = 0,
    baseRentalFee = 0,
    durationText = "",
    priceNote = "",
    durationTooltip = "";

  switch (rentalType) {
    case "hourly":
      const msHourly = endDate.getTime() - startDate.getTime();
      let hours = msHourly / (1000 * 60 * 60);

      if (hours >= 24) {
        // Hiển thị thông báo khuyến nghị
        showFixedAlert("For rentals of 24 hours or more, we recommend switching to daily rental type for better pricing.", "info", false);
      }

      // Giữ nguyên số giờ thực tế (không làm tròn) để tính tiền chính xác
      const exactHours = hours;
      // Đảm bảo tối thiểu 4 giờ
      duration = Math.max(exactHours, 4);
      
      // Tạo text hiển thị chi tiết giờ và phút
      const hoursPart = Math.floor(exactHours);
      const minutesPart = Math.round((exactHours - hoursPart) * 60);
      
      if (minutesPart > 0) {
        durationText = `${hoursPart} hours ${minutesPart} minutes`;
        durationTooltip = `Exact duration: ${exactHours.toFixed(2)} hours.\nCalculation: ${hoursPart} hours and ${minutesPart} minutes = ${exactHours.toFixed(2)} hours.\nBase rental fee = ${exactHours.toFixed(2)} hours × ${formatVND(unitPrice * 1000)}/hour = ${formatVND(exactHours * unitPrice * 1000)}`;
      } else {
        durationText = `${hoursPart} hours`;
        durationTooltip = `Exact duration: ${exactHours.toFixed(2)} hours.\nBase rental fee = ${exactHours.toFixed(2)} hours × ${formatVND(unitPrice * 1000)}/hour = ${formatVND(exactHours * unitPrice * 1000)}`;
      }
      
      unitPrice = carPriceData.hourly || 0;
      break;

    case "daily":
      const msDaily = endDate.getTime() - startDate.getTime();
      const totalHoursDaily = msDaily / (1000 * 60 * 60);
      
      // Tính số ngày chính xác bao gồm phần lẻ
      const exactDays = totalHoursDaily / 24;
      
      // Dùng số ngày chính xác để tính tiền (KHÔNG làm tròn)
      duration = exactDays;
      
      // Tạo text hiển thị chi tiết ngày, giờ và phút
      const daysPart = Math.floor(exactDays);
      const remainingHours = (exactDays - daysPart) * 24;
      const hoursPart2 = Math.floor(remainingHours);
      const minutesPart2 = Math.round((remainingHours - hoursPart2) * 60);
      
      unitPrice = carPriceData.daily || 0;
      
      // Hiển thị chi tiết ngày, giờ và phút
      if (hoursPart2 > 0 && minutesPart2 > 0) {
        durationText = `${daysPart} days ${hoursPart2} hours ${minutesPart2} minutes`;
      } else if (hoursPart2 > 0) {
        durationText = `${daysPart} days ${hoursPart2} hours`;
      } else if (minutesPart2 > 0) {
        durationText = `${daysPart} days ${minutesPart2} minutes`;
        } else {
        durationText = `${daysPart} days`;
      }
      
      durationTooltip = `Exact duration: ${exactDays.toFixed(4)} days.\nCalculation: ${daysPart} days, ${hoursPart2} hours, ${minutesPart2} minutes = ${daysPart} + (${hoursPart2}/24) + (${minutesPart2}/1440) = ${exactDays.toFixed(4)} days.\nBase rental fee = ${exactDays.toFixed(4)} days × ${formatVND(unitPrice * 1000)}/day = ${formatVND(exactDays * unitPrice * 1000)}`;
      break;

    case "monthly":
      const msMonthly = endDate.getTime() - startDate.getTime();
      const daysMonthly = msMonthly / (1000 * 60 * 60 * 24);

      // Tính số tháng chính xác bao gồm phần lẻ
      const exactMonths = daysMonthly / 30;
      
      // Dùng số tháng chính xác để tính tiền (KHÔNG làm tròn và không áp dụng tối thiểu)
      duration = exactMonths;
      
      unitPrice = carPriceData.monthly || 0;
      
      // Tạo text hiển thị chi tiết tháng, ngày, giờ và phút
      const monthsPart = Math.floor(exactMonths);
      const remainingDays = (exactMonths - monthsPart) * 30;
      const daysPart2 = Math.floor(remainingDays);
      const remainingHours2 = (remainingDays - daysPart2) * 24;
      const hoursPart3 = Math.floor(remainingHours2);
      const minutesPart3 = Math.round((remainingHours2 - hoursPart3) * 60);
      
      // Hiển thị chi tiết tháng, ngày, giờ và phút
      let durationParts = [];
      if (monthsPart > 0) durationParts.push(`${monthsPart} months`);
      if (daysPart2 > 0) durationParts.push(`${daysPart2} days`);
      if (hoursPart3 > 0) durationParts.push(`${hoursPart3} hours`);
      if (minutesPart3 > 0) durationParts.push(`${minutesPart3} minutes`);
      
      durationText = durationParts.join(' ');
      
      durationTooltip = `Exact duration: ${exactMonths.toFixed(4)} months.\nCalculation: ${monthsPart} months, ${daysPart2} days, ${hoursPart3} hours, ${minutesPart3} minutes = ${monthsPart} + (${daysPart2}/30) + (${hoursPart3}/720) + (${minutesPart3}/43200) = ${exactMonths.toFixed(4)} months.\nBase rental fee = ${exactMonths.toFixed(4)} months × ${formatVND(unitPrice * 1000)}/month = ${formatVND(exactMonths * unitPrice * 1000)}`;
      break;

    default:
      duration = 0;
      durationText = "Invalid";
      break;
  }

  // Tính tiền thuê xe cơ bản
  baseRentalFee = duration * unitPrice * 1000;
  // Làm tròn đến hàng chục đồng
  baseRentalFee = Math.round(baseRentalFee / 10) * 10;

  // Tính phí bảo hiểm
  // Tính số ngày thuê cho bảo hiểm (luôn làm tròn lên thành ngày đầy đủ)
  let insuranceDays;
  if (rentalType === "hourly") {
    // Với thuê theo giờ, luôn tính tối thiểu 1 ngày bảo hiểm
    insuranceDays = 1;
  } else if (rentalType === "daily") {
    insuranceDays = Math.ceil(duration);
  } else { // monthly
    insuranceDays = Math.ceil(duration * 30);
  }

  // Tính phí bảo hiểm vật chất (bắt buộc)
  const carValue = estimateCarValue(unitPrice);
  let basicInsuranceFeePerDay = calculateBasicInsuranceFee(carValue);
  
  // Giảm 50% phí bảo hiểm vật chất để đồng nhất với backend
  basicInsuranceFeePerDay = basicInsuranceFeePerDay * 0.5;
  
  let basicInsuranceFee = basicInsuranceFeePerDay * insuranceDays;
  // Làm tròn đến hàng chục đồng
  basicInsuranceFee = Math.round(basicInsuranceFee / 10) * 10;

  // Tính phí bảo hiểm tai nạn (tùy chọn)
  const additionalInsuranceFeePerDay = calculateAdditionalInsuranceFee();
  let additionalInsuranceFee = additionalInsurance ? additionalInsuranceFeePerDay * insuranceDays : 0;
  // Làm tròn đến hàng chục đồng
  additionalInsuranceFee = Math.round(additionalInsuranceFee / 10) * 10;

  // Tổng tiền = tiền thuê xe + phí bảo hiểm cơ bản + phí bảo hiểm bổ sung
  let totalPrice = baseRentalFee + basicInsuranceFee + additionalInsuranceFee;
  
  // Làm tròn tổng tiền đến hàng chục đồng để khớp với backend
  totalPrice = Math.round(totalPrice / 10) * 10;

  // Hiển thị giá
  updatePriceDisplay(
    unitPrice,
    baseRentalFee,
    durationText,
    basicInsuranceFee,
    additionalInsuranceFee,
    totalPrice,
    additionalInsurance,
    priceNote,
    durationTooltip,
    basicInsuranceFeePerDay,
    additionalInsuranceFeePerDay,
    insuranceDays
  );
}

// Update price display
function updatePriceDisplay(
  unitPrice,
  baseRentalFee,
  duration,
  basicInsuranceFee,
  additionalInsuranceFee,
  totalPrice,
  hasAdditionalInsurance,
  priceNote = "",
  durationTooltip = "",
  basicInsuranceFeePerDay = 0,
  additionalInsuranceFeePerDay = 0,
  insuranceDays = 0
) {
  const totalDurationElement = document.getElementById("totalDuration");
  const unitPriceElement = document.getElementById("unitPrice");
  const baseRentalFeeElement = document.getElementById("baseRentalFee");
  const basicInsuranceFeeElement = document.getElementById("basicInsuranceFee");
  const additionalInsuranceFeeElement = document.getElementById("additionalInsuranceFee");
  const totalPriceElement = document.getElementById("totalPrice");
  const additionalInsuranceRow = document.getElementById("additionalInsuranceRow");

  // Format currency in VND
  const formatVND = (amount) => {
    // Làm tròn số tiền đến hàng chục đồng (2 số thập phân khi đơn vị là nghìn đồng)
    // Ví dụ: 11.053.125 -> 11.053.130
    const roundedAmount = Math.round(amount / 10) * 10;
    
    return new Intl.NumberFormat('vi-VN', {
      style: 'decimal',
      maximumFractionDigits: 0 // Không hiển thị số thập phân
    }).format(roundedAmount) + " VND";
  };

  if (totalDurationElement) {
    totalDurationElement.textContent = duration;
    
    // Thêm tooltip nếu có
    if (durationTooltip) {
      // Xóa tooltip cũ nếu có
      const oldTooltip = totalDurationElement.querySelector('.duration-tooltip');
      if (oldTooltip) {
        oldTooltip.remove();
      }
      
      // Tạo icon tooltip mới
      const tooltipIcon = document.createElement('i');
      tooltipIcon.className = 'fas fa-question-circle duration-tooltip';
      tooltipIcon.style.marginLeft = '5px';
      tooltipIcon.style.color = '#3182ce';
      tooltipIcon.style.cursor = 'pointer';
      tooltipIcon.title = durationTooltip;
      
      // Thêm tooltip vào element
      totalDurationElement.appendChild(tooltipIcon);
      
      // Thêm tooltip bằng bootstrap hoặc thư viện tooltip khác nếu có
      try {
        if (typeof $(tooltipIcon).tooltip === 'function') {
          $(tooltipIcon).tooltip({html: true});
        }
      } catch (e) {
        console.log('Bootstrap tooltip not available');
      }
    }
  }
  
  if (unitPriceElement) unitPriceElement.textContent = formatVND(unitPrice * 1000);
  if (baseRentalFeeElement) baseRentalFeeElement.textContent = formatVND(baseRentalFee);
  
  if (basicInsuranceFeeElement) {
    // Hiển thị giá bảo hiểm cơ bản
    basicInsuranceFeeElement.textContent = formatVND(basicInsuranceFee);
    
    // Xóa tất cả các tooltip và thông tin phụ cũ
    const parentElement = basicInsuranceFeeElement.parentNode;
    if (parentElement) {
      const oldTooltips = parentElement.querySelectorAll('.insurance-tooltip');
      oldTooltips.forEach(el => el.remove());
      
      const oldInfos = parentElement.querySelectorAll('.insurance-info');
      oldInfos.forEach(el => el.remove());
    }
    
    // Thêm tooltip giải thích cách tính bảo hiểm (chỉ hiển thị khi hover)
    const dailyRateForInsurance = carPriceData && carPriceData.daily ? carPriceData.daily * 1000 : unitPrice * 1000 * 24;
    const basicInsuranceTooltip = `Material insurance: ${formatVND(basicInsuranceFeePerDay*2)}/day (full price) × 50% discount = ${formatVND(basicInsuranceFeePerDay)}/day × ${insuranceDays} days = ${formatVND(basicInsuranceFee)}\n(Based on daily rate: ${formatVND(dailyRateForInsurance)}/day)`;
    
    // Tạo icon tooltip
    const basicTooltipIcon = document.createElement('i');
    basicTooltipIcon.className = 'fas fa-question-circle insurance-tooltip';
    basicTooltipIcon.style.marginLeft = '5px';
    basicTooltipIcon.style.color = '#3182ce';
    basicTooltipIcon.style.cursor = 'pointer';
    basicTooltipIcon.title = basicInsuranceTooltip;
    
    // Thêm tooltip vào element
    if (parentElement) {
      parentElement.appendChild(basicTooltipIcon);
    }
    
    // Thêm tooltip bằng bootstrap hoặc thư viện tooltip khác nếu có
    try {
      if (typeof $(basicTooltipIcon).tooltip === 'function') {
        $(basicTooltipIcon).tooltip();
      }
    } catch (e) {
      console.log('Bootstrap tooltip not available');
    }
  }
  
  if (totalPriceElement) {
    totalPriceElement.textContent = formatVND(totalPrice);
    
    // Xóa tooltip cũ nếu có
    const parentElement = totalPriceElement.parentNode;
    if (parentElement) {
      const oldTooltips = parentElement.querySelectorAll('.price-tooltip');
      oldTooltips.forEach(el => el.remove());
    }
    
    // Thêm tooltip giải thích cách tính giá
    const dailyRateForInsurance = carPriceData && carPriceData.daily ? carPriceData.daily * 1000 : unitPrice * 1000 * 24;
    const pricingExplanation = `Base rental: ${formatVND(baseRentalFee)}\nMaterial insurance: ${formatVND(basicInsuranceFee)} (${formatVND(basicInsuranceFeePerDay*2)}/day full price × 50% discount = ${formatVND(basicInsuranceFeePerDay)}/day × ${insuranceDays} days)\n(Based on daily rate: ${formatVND(dailyRateForInsurance)}/day)${hasAdditionalInsurance ? '\nAccident insurance: ' + formatVND(additionalInsuranceFee) + ' (' + formatVND(additionalInsuranceFeePerDay) + '/day × ' + insuranceDays + ' days)' : ''}`;
    
    // Tạo icon tooltip mới
    const priceTooltipIcon = document.createElement('i');
    priceTooltipIcon.className = 'fas fa-question-circle price-tooltip';
    priceTooltipIcon.style.marginLeft = '5px';
    priceTooltipIcon.style.color = '#3182ce';
    priceTooltipIcon.style.cursor = 'pointer';
    priceTooltipIcon.title = pricingExplanation;
    
    // Thêm tooltip vào element
    if (parentElement) {
      parentElement.appendChild(priceTooltipIcon);
    }
    
    // Thêm tooltip bằng bootstrap hoặc thư viện tooltip khác nếu có
    try {
      if (typeof $(priceTooltipIcon).tooltip === 'function') {
        $(priceTooltipIcon).tooltip();
      }
    } catch (e) {
      console.log('Bootstrap tooltip not available');
    }
  }

  // Show/hide additional insurance row
  if (additionalInsuranceRow) {
    additionalInsuranceRow.style.display = hasAdditionalInsurance ? "flex" : "none";
    if (hasAdditionalInsurance && additionalInsuranceFeeElement) {
      additionalInsuranceFeeElement.textContent = formatVND(additionalInsuranceFee);
      
      // Xóa tất cả các tooltip và thông tin phụ cũ
      const parentElement = additionalInsuranceFeeElement.parentNode;
      if (parentElement) {
        const oldTooltips = parentElement.querySelectorAll('.insurance-tooltip');
        oldTooltips.forEach(el => el.remove());
        
        const oldInfos = parentElement.querySelectorAll('.insurance-info');
        oldInfos.forEach(el => el.remove());
      }
      
      // Thêm tooltip giải thích cách tính bảo hiểm bổ sung
      const additionalInsuranceTooltip = `Accident insurance: ${formatVND(additionalInsuranceFeePerDay)}/day × ${insuranceDays} days = ${formatVND(additionalInsuranceFee)}`;
      
      // Tạo icon tooltip
      const additionalTooltipIcon = document.createElement('i');
      additionalTooltipIcon.className = 'fas fa-question-circle insurance-tooltip';
      additionalTooltipIcon.style.marginLeft = '5px';
      additionalTooltipIcon.style.color = '#3182ce';
      additionalTooltipIcon.style.cursor = 'pointer';
      additionalTooltipIcon.title = additionalInsuranceTooltip;
      
      // Thêm tooltip vào element
      if (parentElement) {
        parentElement.appendChild(additionalTooltipIcon);
      }
    }
  }
  
  // Hiển thị ghi chú về giá nếu có
  if (priceNote) {
    const priceNoteElement = document.getElementById("priceNote");
    if (priceNoteElement) {
      priceNoteElement.textContent = priceNote;
      priceNoteElement.style.display = "block";
    } else {
      // Tạo element mới nếu chưa có
      const noteElement = document.createElement("div");
      noteElement.id = "priceNote";
      noteElement.className = "price-note";
      noteElement.textContent = priceNote;
      noteElement.style.color = "#4a5568";
      noteElement.style.fontSize = "14px";
      noteElement.style.fontStyle = "italic";
      noteElement.style.marginTop = "8px";
      noteElement.style.paddingLeft = "10px";
      noteElement.style.borderLeft = "2px solid #4299e1";
      
      // Thêm vào sau phần tổng giá
      const totalPriceRow = totalPriceElement?.closest(".price-row");
      if (totalPriceRow && totalPriceRow.parentNode) {
        totalPriceRow.parentNode.insertBefore(noteElement, totalPriceRow.nextSibling);
      }
    }
  } else {
    // Ẩn ghi chú nếu không có
    const priceNoteElement = document.getElementById("priceNote");
    if (priceNoteElement) {
      priceNoteElement.style.display = "none";
    }
  }
}

// Hàm formatVND để sử dụng ở nhiều nơi
function formatVND(amount) {
  // Làm tròn số tiền đến hàng chục đồng (2 số thập phân khi đơn vị là nghìn đồng)
  // Ví dụ: 11.053.125 -> 11.053.130
  const roundedAmount = Math.round(amount / 10) * 10;
  
  return new Intl.NumberFormat('vi-VN', {
    style: 'decimal',
    maximumFractionDigits: 0 // Không hiển thị số thập phân
  }).format(roundedAmount) + " VND";
}

// Form validation
function validateForm() {
  const form = document.getElementById("bookingForm")
  if (!form) {
    return false
  }

  let isValid = true

  const existingAlerts = document.querySelectorAll(".alert.alert-danger")
  existingAlerts.forEach((alert) => alert.remove())

  const requiredFields = form.querySelectorAll("[required]")
  requiredFields.forEach((field) => {
    field.style.borderColor = ""
  })

  requiredFields.forEach((field, index) => {
    if (!field.value.trim()) {
      field.style.borderColor = "#ef4444"
      isValid = false
    }
  })

  // Enhanced date and time validation - đã được Flatpickr xử lý phần lớn
  const startDateInput = document.getElementById("startDate")
  const endDateInput = document.getElementById("endDate")

  if (startDateInput && endDateInput) {
    const startDate = parseLocalDateTime("startDate");
    const endDate = parseLocalDateTime("endDate");

    if (!startDate) {
      showAlert("Please select a pickup date and time", "error");
      startDateInput.style.borderColor = "#ef4444";
      isValid = false;
    }
    
    if (!endDate) {
      showAlert("Please select a return date and time", "error");
      endDateInput.style.borderColor = "#ef4444";
      isValid = false;
    }
    
    if (startDate && endDate) {
      // Kiểm tra end date có sau start date không
      if (endDate <= startDate) {
        showAlert("End date must be after start date", "error");
        endDateInput.style.borderColor = "#ef4444";
        isValid = false;
      }
      
      // Kiểm tra thời gian tối thiểu
      const minTime = new Date();
      const currentMinutes = minTime.getMinutes();
      
      // Log thời gian hiện tại để debug
      console.log("Current time:", minTime.toLocaleTimeString());
      
      // Tính toán thời gian tối thiểu dựa trên quy tắc làm tròn
      if (currentMinutes < 25) {
        // Làm tròn lên 30 phút của giờ hiện tại
        minTime.setMinutes(30, 0, 0);
      } else if (currentMinutes < 55) {
        // Làm tròn lên giờ tiếp theo
        minTime.setHours(minTime.getHours() + 1, 0, 0, 0);
      } else {
        // Làm tròn lên 30 phút của giờ tiếp theo
        minTime.setHours(minTime.getHours() + 1, 30, 0, 0);
      }
      
      // Đảm bảo thời gian tối thiểu không sớm hơn thời gian hiện tại + 5 phút
      const bufferTime = new Date();
      bufferTime.setMinutes(bufferTime.getMinutes() + 5);
      
      if (minTime < bufferTime) {
        // Nếu thời gian làm tròn < thời gian hiện tại + 5 phút, đẩy lên 30 phút tiếp theo
        if (minTime.getMinutes() === 0) {
          minTime.setMinutes(30);
        } else {
          minTime.setHours(minTime.getHours() + 1, 0, 0, 0);
        }
      }
      
      // Nếu minTime < 7:00, đặt thành 7:00
      if (minTime.getHours() < 7) {
        minTime.setHours(7, 0, 0);
      }
      
      // Nếu minTime > 22:00, đặt thành 7:00 ngày hôm sau
      if (minTime.getHours() >= 22) {
        minTime.setDate(minTime.getDate() + 1);
        minTime.setHours(7, 0, 0);
      }
      
      // Log thời gian tối thiểu sau khi tính toán
      console.log("Minimum time calculated:", minTime.toLocaleTimeString());
      console.log("Start date selected:", startDate.toLocaleTimeString());
      
      // So sánh thời gian bắt đầu với thời gian tối thiểu
      // Chỉ so sánh nếu là cùng ngày
      const isSameDay = startDate.getDate() === minTime.getDate() && 
                        startDate.getMonth() === minTime.getMonth() && 
                        startDate.getFullYear() === minTime.getFullYear();
                        
      if (isSameDay && startDate < minTime) {
        showAlert(`Pickup time must be at least ${minTime.getHours()}:${minTime.getMinutes() === 0 ? '00' : minTime.getMinutes()} or later`, "error");
        startDateInput.style.borderColor = "#ef4444";
        isValid = false;
      }
      
      // Kiểm tra thời gian tối thiểu giữa start và end (4 giờ)
      const hoursDiff = (endDate - startDate) / (1000 * 60 * 60);
      
      // Kiểm tra xem thời gian kết thúc có phải là ngày hôm sau không
      const isNextDay = endDate.getDate() > startDate.getDate() || 
                        endDate.getMonth() > startDate.getMonth() || 
                        endDate.getFullYear() > startDate.getFullYear();
      
      // Chỉ kiểm tra thời gian tối thiểu 4 giờ nếu không phải ngày hôm sau
      if (hoursDiff < 4 && !isNextDay) {
        showAlert("Minimum rental duration is 4 hours", "error");
        endDateInput.style.borderColor = "#ef4444";
        isValid = false;
      }
    }
  }

  const licenseNumber = document.getElementById("licenseNumber")
  if (licenseNumber && licenseNumber.hasAttribute("required")) {
    const licensePattern = /^[0-9]{12}$/
    if (!licensePattern.test(licenseNumber.value)) {
      showAlert("Driver license number must be exactly 12 digits.", "error")
      licenseNumber.style.borderColor = "#ef4444"
      isValid = false
    }
  }

  // Validate phone number
  const phoneInput = document.getElementById("customerPhone")
  if (phoneInput && phoneInput.value.trim()) {
    if (!validatePhone(phoneInput.value)) {
      showAlert("Please enter a valid phone number (10-11 digits)", "error")
      phoneInput.style.borderColor = "#ef4444"
      isValid = false
    }
  }

  if (!isValid) {
    showAlert("Please fill in all required fields correctly.", "error")
  }

  return isValid
}

// Show alert message with improved visibility
function showAlert(message, type = "info") {
  // Sử dụng hàm showFixedAlert nếu có
  if (typeof showFixedAlert === 'function') {
    showFixedAlert(message, type);
    return;
  }
  
  // Fallback nếu không có hàm showFixedAlert
  const formContainer = document.querySelector(".booking-form-container")
  if (!formContainer) return

  // Remove existing alerts
  const existingAlerts = formContainer.querySelectorAll(".alert:not(.mb-3)")
  existingAlerts.forEach((alert) => {
      alert.remove()
  })

  // Create new alert
  const alertDiv = document.createElement("div")
  alertDiv.className = `alert alert-${type === "error" ? "danger" : type === "success" ? "success" : type === "warning" ? "warning" : "info"}`
  alertDiv.innerHTML = `
        <i class="fas fa-${type === "error" ? "exclamation-triangle" : type === "success" ? "check-circle" : type === "warning" ? "exclamation-circle" : "info-circle"}"></i>
        <span>${message}</span>
    `

  // Make alert more visible
  alertDiv.style.marginBottom = "1rem"
  alertDiv.style.padding = "12px 15px"
  alertDiv.style.fontSize = "14px"
  alertDiv.style.fontWeight = "500"
  alertDiv.style.borderWidth = "2px"
  
  // Different styling based on alert type
  if (type === "error") {
    alertDiv.style.backgroundColor = "#fff5f5"
    alertDiv.style.borderColor = "#f56565"
  } else if (type === "warning") {
    alertDiv.style.backgroundColor = "#fffbeb"
    alertDiv.style.borderColor = "#f59e0b"
  }

  // Insert alert at the top of the form
  const firstElement = formContainer.querySelector("form") || formContainer.firstChild
  formContainer.insertBefore(alertDiv, firstElement)

  // Auto remove alert after 5 seconds
  setTimeout(() => {
    if (alertDiv.parentNode) {
      alertDiv.remove()
    }
  }, 5000)
}

// Expose functions globally
window.hideInputWarning = hideInputWarning;
window.showInputWarning = showInputWarning;

// Navigation functions
function goHome() {
  if (confirm("Are you sure you want to return to the home page? Entered information will be lost.")) {
    window.location.href = "/"
  }
}

function goToDeposit() {
  if (validateForm()) {
    const form = document.getElementById("bookingForm")
    const formData = new FormData(form)
    const formObject = {}
    formData.forEach((value, key) => {
      formObject[key] = value
    })

    sessionStorage.setItem("bookingFormData", JSON.stringify(formObject))

    // This should point to the correct deposit page URL
    window.location.href = "/pages/booking-form/booking-form-deposit.jsp"
  } else {
    showAlert("Please fix the form errors before proceeding.", "error")
  }
}



// Utility function to validate phone number
function validatePhone(phone) {
  const phonePattern = /^[0-9]{10,11}$/
  return phonePattern.test(phone.replace(/\s/g, ""))
}

// Cập nhật hàm showFixedAlert để không tự động ẩn
function showFixedAlert(message, type, autoHide = false) {
  if (typeof window.showFixedAlert === 'function') {
    window.showFixedAlert(message, type, autoHide);
    return;
  }
  
  // Fallback nếu không có hàm showFixedAlert
  showAlert(message, type);
}

// Ước tính giá trị xe dựa trên giá thuê ngày
function estimateCarValue(unitPrice) {
  // Luôn sử dụng giá thuê theo ngày để tính giá trị xe
  let dailyRate;
  
  // Lấy giá thuê theo ngày từ carPriceData
  if (carPriceData && carPriceData.daily) {
    dailyRate = carPriceData.daily * 1000; // Chuyển đổi từ nghìn VND sang VND
  } else {
    // Nếu không có giá thuê theo ngày, sử dụng giá thuê theo giờ * 24 làm giá thuê ngày
    dailyRate = unitPrice * 1000 * 24;
  }
  
  // Xác định hệ số năm sử dụng dựa trên giá thuê
  let yearCoefficient;
  if (dailyRate <= 500000) {
    yearCoefficient = 5; // Hệ số thấp
  } else if (dailyRate <= 800000) {
    yearCoefficient = 7; // Hệ số trung bình
  } else if (dailyRate <= 1200000) {
    yearCoefficient = 10; // Hệ số cao
  } else {
    yearCoefficient = 15; // Hệ số cao cấp
  }
  
  // Ước tính giá trị xe = giá thuê ngày * 365 * hệ số năm
  return dailyRate * 365 * yearCoefficient;
}

// Tính phí bảo hiểm vật chất (bắt buộc) dựa trên giá trị xe
function calculateBasicInsuranceFee(carValue) {
  // Phí bảo hiểm vật chất = 2% giá trị xe / 365 ngày
  const annualRate = 0.02; // 2%
  return (carValue * annualRate) / 365;
}

// Tính phí bảo hiểm tai nạn (tùy chọn) dựa trên số chỗ ngồi của xe
function calculateAdditionalInsuranceFee() {
  // Lấy số chỗ ngồi từ hidden input nếu có
  let carSeats = 0;
  try {
    const carSeatsElement = document.getElementById("carSeatsHidden");
    if (carSeatsElement) {
      carSeats = parseInt(carSeatsElement.value, 10);
    }
  } catch (e) {
    console.error("Error parsing car seats:", e);
  }
  
  // Xác định phí bảo hiểm tai nạn dựa trên số chỗ ngồi
  if (carSeats <= 5) {
    return 30000; // 30k/ngày cho xe dưới 5 chỗ
  } else if (carSeats <= 11) {
    return 40000; // 40k/ngày cho xe 6-11 chỗ
  } else {
    return 50000; // 50k/ngày cho xe 12+ chỗ
  }
}

