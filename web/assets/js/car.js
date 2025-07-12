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