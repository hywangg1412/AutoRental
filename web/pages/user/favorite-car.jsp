
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Favorite Cars - Auto Rental</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

        <<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/user/favorite-car.css"/>

    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center py-3">
                    <div class="logo">
                        <span class="text-dark">AUTO</span><span class="text-success">RENTAL</span>
                    </div>
                    <div class="d-flex align-items-center gap-4">
                        <nav class="nav-links d-flex gap-4">
                            <a href="#" class="fw-medium">About</a>
                            <a href="#" class="fw-medium">My trips</a>
                        </nav>
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-bell"></i>
                            <i class="bi bi-chat-dots"></i>
                            <div class="dropdown">
                                <button class="btn btn-link text-decoration-none text-dark dropdown-toggle d-flex align-items-center gap-2" 
                                        type="button" data-bs-toggle="dropdown">
                                    <div class="user-avatar rounded-circle"></div>
                                    <span>hywang1412</span>
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#">Profile</a></li>
                                    <li><a class="dropdown-item" href="#">Settings</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="#">Logout</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <div class="container-fluid mt-4">
            <div class="row g-4">
                <!-- Sidebar -->
                <div class="col-lg-3">
                    <div class="sidebar p-4">
                        <h2 class="h4 fw-bold mb-4">Hello !</h2>
                        <ul class="sidebar-menu">
                            <li><a href="my-account.jsp" class="nav-link">
                                    <i class="bi bi-person"></i>
                                    My account
                                </a></li>
                            <li><a href="favorite-car.jsp" class="nav-link active">
                                    <i class="bi bi-heart"></i>
                                    Favorite cars
                                </a></li>
                            <li><a href="my-trip.jsp" class="nav-link">
                                    <i class="bi bi-car-front"></i>
                                    My trips
                                </a></li>
                            <li><a href="longterm-booking.jsp" class="nav-link">
                                    <i class="bi bi-clipboard-check"></i>
                                    Long-term car rental orders
                                </a></li>
                            <li><a href="my-address.jsp" class="nav-link">
                                    <i class="bi bi-geo-alt"></i>
                                    My address
                                </a></li>
                            <li><a href="change-password.jsp" class="nav-link">
                                    <i class="bi bi-lock"></i>
                                    Change password
                                </a></li>
                            <li><a href="request-delete.jsp" class="nav-link">
                                    <i class="bi bi-trash"></i>
                                    Request account deletion
                                </a></li>
                            <li class="mt-3"><a href="#" class="nav-link text-danger">
                                    <i class="bi bi-box-arrow-right"></i>
                                    Log out
                                </a></li>
                        </ul>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="col-lg-9">
                    <div class="main-content p-4">
                        <!-- Page Header -->
                        <div class="mb-4">
                            <h1 class="h4 fw-semibold mb-0">My Favorite Car</h1>
                        </div>

                        <!-- Car Cards -->
                        <div class="car-cards">
                            <!-- Car Card 1 -->
                            <div class="car-card">
                                <div class="row align-items-center">
                                    <div class="col-md-3">
                                        <div class="car-image"></div>
                                    </div>
                                    <div class="col-md-6">
                                        <h3 class="car-title">KIA SEDONA PREMIUM 2017</h3>
                                        <div class="car-specs">
                                            <span class="car-spec">
                                                <i class="bi bi-gear"></i>
                                                Automatic transmission
                                            </span>
                                            <span class="car-spec">
                                                <i class="bi bi-people"></i>
                                                7 seats
                                            </span>
                                            <span class="car-spec">
                                                <i class="bi bi-fuel-pump"></i>
                                                Gas
                                            </span>
                                        </div>
                                        <div class="car-location">
                                            <i class="bi bi-geo-alt"></i>
                                            <span>Quận Thanh Khê, Đà Nẵng</span>
                                        </div>
                                        <div class="car-rating">
                                            <div class="stars">
                                                <i class="bi bi-star-fill"></i>
                                                <span class="fw-medium">5.0</span>
                                            </div>
                                            <span class="rating-text">35 trip</span>
                                        </div>
                                    </div>
                                    <div class="col-md-3 text-end">
                                        <div class="car-pricing">
                                            <span class="original-price">1,421K</span>
                                            <span class="current-price">1,301K/day</span>
                                        </div>
                                        <button class="btn btn-unlike mt-3">Unlike</button>
                                        <a href="#" class="view-details d-block">View details</a>
                                    </div>
                                </div>
                            </div>

                            <!-- Car Card 2 -->
                            <div class="car-card">
                                <div class="row align-items-center">
                                    <div class="col-md-3">
                                        <div class="car-image"></div>
                                    </div>
                                    <div class="col-md-6">
                                        <h3 class="car-title">KIA SEDONA PREMIUM 2017</h3>
                                        <div class="car-specs">
                                            <span class="car-spec">
                                                <i class="bi bi-gear"></i>
                                                Automatic transmission
                                            </span>
                                            <span class="car-spec">
                                                <i class="bi bi-people"></i>
                                                7 seats
                                            </span>
                                            <span class="car-spec">
                                                <i class="bi bi-fuel-pump"></i>
                                                Gas
                                            </span>
                                        </div>
                                        <div class="car-location">
                                            <i class="bi bi-geo-alt"></i>
                                            <span>Quận Thanh Khê, Đà Nẵng</span>
                                        </div>
                                        <div class="car-rating">
                                            <div class="stars">
                                                <i class="bi bi-star-fill"></i>
                                                <span class="fw-medium">5.0</span>
                                            </div>
                                            <span class="rating-text">35 trip</span>
                                        </div>
                                    </div>
                                    <div class="col-md-3 text-end">
                                        <div class="car-pricing">
                                            <span class="original-price">1,421K</span>
                                            <span class="current-price">1,301K/day</span>
                                        </div>
                                        <button class="btn btn-unlike mt-3">Unlike</button>
                                        <a href="#" class="view-details d-block">View details</a>
                                    </div>
                                </div>
                            </div>

                            <!-- Car Card 3 -->
                            <div class="car-card">
                                <div class="row align-items-center">
                                    <div class="col-md-3">
                                        <div class="car-image"></div>
                                    </div>
                                    <div class="col-md-6">
                                        <h3 class="car-title">KIA SEDONA PREMIUM 2017</h3>
                                        <div class="car-specs">
                                            <span class="car-spec">
                                                <i class="bi bi-gear"></i>
                                                Automatic transmission
                                            </span>
                                            <span class="car-spec">
                                                <i class="bi bi-people"></i>
                                                7 seats
                                            </span>
                                            <span class="car-spec">
                                                <i class="bi bi-fuel-pump"></i>
                                                Gas
                                            </span>
                                        </div>
                                        <div class="car-location">
                                            <i class="bi bi-geo-alt"></i>
                                            <span>Quận Thanh Khê, Đà Nẵng</span>
                                        </div>
                                        <div class="car-rating">
                                            <div class="stars">
                                                <i class="bi bi-star-fill"></i>
                                                <span class="fw-medium">5.0</span>
                                            </div>
                                            <span class="rating-text">35 trip</span>
                                        </div>
                                    </div>
                                    <div class="col-md-3 text-end">
                                        <div class="car-pricing">
                                            <span class="original-price">1,421K</span>
                                            <span class="current-price">1,301K/day</span>
                                        </div>
                                        <button class="btn btn-unlike mt-3">Unlike</button>
                                        <a href="#" class="view-details d-block">View details</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Unlike button functionality
            document.querySelectorAll('.btn-unlike').forEach(button => {
                button.addEventListener('click', function () {
                    const card = this.closest('.car-card');
                    card.style.transition = 'all 0.3s ease';
                    card.style.opacity = '0.5';
                    card.style.transform = 'scale(0.95)';

                    setTimeout(() => {
                        card.remove();
                    }, 300);
                });
            });
        </script>
    </body>
</html>