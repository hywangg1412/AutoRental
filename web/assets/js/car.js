function toggleFeatureFilter() {
                                var content = document.getElementById('feature-filter-content');
                                var icon = document.getElementById('feature-toggle-icon');
                                if(content.style.display === 'none') {
                                    content.style.display = 'block';
                                    icon.innerHTML = '&#9660;';
                                } else {
                                    content.style.display = 'none';
                                    icon.innerHTML = '&#9654;';
                                }
                            }
                            // Mặc định thu gọn nếu nhiều tính năng
                            window.onload = function() {
                                var content = document.getElementById('feature-filter-content');
                                if(content && content.children.length > 6) {
                                    content.style.display = 'none';
                                    document.getElementById('feature-toggle-icon').innerHTML = '&#9654;';
                                }
                            }
 
window.addEventListener('DOMContentLoaded', function() {
          // Giá
          var priceSlider = document.getElementById('priceRangeSlider');
          if (priceSlider) {
            noUiSlider.create(priceSlider, {
              start: [parseInt(document.getElementById('minPriceInput').value), parseInt(document.getElementById('maxPriceInput').value)],
              connect: true,
              step: 10000,
              range: { 'min': 0, 'max': 500000 },
              tooltips: false,
              format: {
                to: function (value) { return Math.round(value); },
                from: function (value) { return Number(value); }
              }
            });
            priceSlider.noUiSlider.on('update', function(values, handle) {
              document.getElementById('priceMinVal').innerText = Number(values[0]).toLocaleString('vi-VN');
              document.getElementById('priceMaxVal').innerText = Number(values[1]).toLocaleString('vi-VN');
              document.getElementById('minPriceInput').value = values[0];
              document.getElementById('maxPriceInput').value = values[1];
            });
          }
          // Năm sản xuất
          var yearSlider = document.getElementById('yearRangeSlider');
          if (yearSlider) {
            noUiSlider.create(yearSlider, {
              start: [parseInt(document.getElementById('minYearInput').value), parseInt(document.getElementById('maxYearInput').value)],
              connect: true,
              step: 1,
              range: { 'min': 2000, 'max': 2024 },
              tooltips: false,
              format: {
                to: function (value) { return Math.round(value); },
                from: function (value) { return Number(value); }
              }
            });
            yearSlider.noUiSlider.on('update', function(values, handle) {
              document.getElementById('yearMinVal').innerText = Math.round(values[0]);
              document.getElementById('yearMaxVal').innerText = Math.round(values[1]);
              document.getElementById('minYearInput').value = values[0];
              document.getElementById('maxYearInput').value = values[1];
            });
          }
        });
        
        // Favorite toggle logic
        function showFavoriteToast(msg, isRemove) {
            var toast = document.getElementById('favorite-toast');
            toast.textContent = msg;
            toast.className = isRemove ? 'remove' : '';
            toast.style.display = 'flex';
            setTimeout(function() { toast.style.display = 'none'; }, 1800);
        }

        function getFavoriteCars() {
            try {
                return JSON.parse(localStorage.getItem('favoriteCars') || '[]');
            } catch { return []; }
        }
        function setFavoriteCars(arr) {
            localStorage.setItem('favoriteCars', JSON.stringify(arr));
        }

        function updateFavoriteButtons() {
            var favs = getFavoriteCars();
            document.querySelectorAll('.favorite-btn[data-car-id]').forEach(function(btn) {
                var carId = btn.getAttribute('data-car-id');
                var icon = btn.querySelector('i');
                if (favs.includes(carId)) {
                    btn.classList.add('active');
                    if (icon) { icon.classList.remove('bi-heart'); icon.classList.add('bi-heart-fill'); }
                } else {
                    btn.classList.remove('active');
                    if (icon) { icon.classList.remove('bi-heart-fill'); icon.classList.add('bi-heart'); }
                }
            });
        }

        document.addEventListener('DOMContentLoaded', function() {
            // Gán data-car-id cho từng nút
            document.querySelectorAll('.favorite-btn').forEach(function(btn) {
                var carWrap = btn.closest('.car-wrap');
                if (carWrap) {
                    var carId = carWrap.querySelector('a[href*="carId="]')?.href.match(/carId=(\d+)/)?.[1];
                    if (carId) btn.setAttribute('data-car-id', carId);
                }
            });
            updateFavoriteButtons();
            document.querySelectorAll('.favorite-btn').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var carId = btn.getAttribute('data-car-id');
                    var favs = getFavoriteCars();
                    var idx = favs.indexOf(carId);
                    var icon = btn.querySelector('i');
                    if (idx === -1) {
                        favs.push(carId);
                        setFavoriteCars(favs);
                        btn.classList.add('active');
                        if (icon) { icon.classList.remove('bi-heart'); icon.classList.add('bi-heart-fill'); }
                        showFavoriteToast('Success add to favorite', false);
                    } else {
                        favs.splice(idx, 1);
                        setFavoriteCars(favs);
                        btn.classList.remove('active');
                        if (icon) { icon.classList.remove('bi-heart-fill'); icon.classList.add('bi-heart'); }
                        showFavoriteToast('Success remove from favorite', true);
                    }
                });
            });
        });