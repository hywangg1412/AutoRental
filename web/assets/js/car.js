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