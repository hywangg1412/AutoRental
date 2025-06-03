
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - Auto Rental</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        :root {
            --primary-green: #10b981;
            --light-green: #f0fdf4;
            --warning-orange: #f59e0b;
            --danger-red: #dc2626;
            --light-gray: #f8f9fa;
            --border-gray: #e5e7eb;
            --text-gray: #6b7280;
        }

        body {
            background-color: var(--light-gray);
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        .header {
            background: white;
            border-bottom: 1px solid var(--border-gray);
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .logo {
            font-weight: bold;
            font-size: 1.25rem;
        }

        .logo .text-dark {
            color: #333 !important;
        }

        .logo .text-success {
            color: var(--primary-green) !important;
        }

        .nav-links a {
            color: var(--text-gray);
            text-decoration: none;
            transition: color 0.2s;
        }

        .nav-links a:hover {
            color: var(--primary-green);
        }

        .user-avatar {
            width: 32px;
            height: 32px;
            background-color: #d1d5db;
        }

        .sidebar {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            height: fit-content;
        }

        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar-menu .nav-link {
            color: var(--text-gray);
            border-radius: 0;
            padding: 0.75rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            transition: all 0.2s;
            border: none;
        }

        .sidebar-menu .nav-link:hover {
            background-color: #f3f4f6;
            color: var(--primary-green);
        }

        .sidebar-menu .nav-link.active {
            background-color: var(--light-green);
            color: var(--primary-green);
            border-right: 3px solid var(--primary-green);
        }

        .sidebar-menu .nav-link.text-danger:hover {
            background-color: #fee2e2;
            color: var(--danger-red);
        }

        .main-content {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .trips-badge {
            background-color: var(--light-green);
            color: var(--primary-green);
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .points-badge {
            color: var(--warning-orange);
            font-weight: 500;
        }

        .not-verified {
            background-color: #fef3c7;
            color: #d97706;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .verification-failed {
            background-color: #fee2e2;
            color: var(--danger-red);
            font-size: 0.75rem;
            font-weight: 500;
        }

        .add-link {
            color: var(--primary-green);
            text-decoration: none;
            font-size: 0.875rem;
        }

        .add-link:hover {
            color: var(--primary-green);
            text-decoration: underline;
        }

        .info-row {
            border-bottom: 1px solid #f3f4f6;
        }

        .upload-area {
            border: 2px dashed #d1d5db;
            border-radius: 8px;
            background-color: #f9fafb;
            transition: all 0.2s;
        }

        .upload-area:hover {
            border-color: var(--primary-green);
            background-color: var(--light-green);
        }

        .upload-icon {
            width: 48px;
            height: 48px;
            background-color: var(--primary-green);
            color: white;
            font-size: 1.5rem;
        }

        .form-control:focus {
            border-color: var(--primary-green);
            box-shadow: 0 0 0 0.2rem rgba(16, 185, 129, 0.25);
        }

        .btn-outline-secondary:hover {
            background-color: var(--primary-green);
            border-color: var(--primary-green);
        }

        .dropdown-toggle::after {
            margin-left: 0.5rem;
        }
    </style>
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
                        <li><a href="#" class="nav-link active">
                            <i class="bi bi-person"></i>
                            My account
                        </a></li>
                        <li><a href="#" class="nav-link">
                            <i class="bi bi-heart"></i>
                            Favorite cars
                        </a></li>
                        <li><a href="#" class="nav-link">
                            <i class="bi bi-car-front"></i>
                            My trips
                        </a></li>
                        <li><a href="#" class="nav-link">
                            <i class="bi bi-clipboard-check"></i>
                            Long-term car rental orders
                        </a></li>
                        <li><a href="#" class="nav-link">
                            <i class="bi bi-geo-alt"></i>
                            My address
                        </a></li>
                        <li><a href="#" class="nav-link">
                            <i class="bi bi-lock"></i>
                            Change password
                        </a></li>
                        <li><a href="#" class="nav-link">
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
                    <!-- Account Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="d-flex align-items-center gap-3">
                            <h1 class="h4 fw-semibold mb-0">Account Information</h1>
                            <i class="bi bi-pencil text-muted"></i>
                        </div>
                        <span class="badge trips-badge px-3 py-2">
                            <i class="bi bi-car-front me-1"></i>0 trips
                        </span>
                    </div>

                    <!-- User Info -->
                    <div class="row g-5 mb-5">
                        <div class="col-md-6">
                            <h2 class="h5 fw-semibold mb-2">hywang1412</h2>
                            <p class="text-muted mb-3">Joined 23/09/2025</p>
                            <div class="points-badge d-flex align-items-center gap-2">
                                <i class="bi bi-star-fill"></i>
                                <span>0 Point</span>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="info-row d-flex justify-content-between align-items-center py-3">
                                <span class="text-muted">Date of birth</span>
                                <span class="fw-medium">--/--/----</span>
                            </div>
                            <div class="info-row d-flex justify-content-between align-items-center py-3">
                                <span class="text-muted">Gender</span>
                                <span class="fw-medium">Male</span>
                            </div>
                            <div class="info-row d-flex justify-content-between align-items-center py-3">
                                <span class="text-muted">Phone Number</span>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge not-verified px-2 py-1">Not verified</span>
                                    <span class="fw-medium">+84831837721</span>
                                    <i class="bi bi-pencil text-muted"></i>
                                </div>
                            </div>
                            <div class="info-row d-flex justify-content-between align-items-center py-3">
                                <span class="text-muted">Email</span>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge not-verified px-2 py-1">Not verified</span>
                                    <a href="#" class="add-link">Add email</a>
                                    <i class="bi bi-pencil text-muted"></i>
                                </div>
                            </div>
                            <div class="info-row d-flex justify-content-between align-items-center py-3">
                                <span class="text-muted">Facebook</span>
                                <div class="d-flex align-items-center gap-2">
                                    <a href="#" class="add-link">Add a link</a>
                                    <i class="bi bi-pencil text-muted"></i>
                                </div>
                            </div>
                            <div class="info-row d-flex justify-content-between align-items-center py-3">
                                <span class="text-muted">Google</span>
                                <div class="d-flex align-items-center gap-2">
                                    <a href="#" class="add-link">Add a link</a>
                                    <i class="bi bi-pencil text-muted"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Driver's License Section -->
                    <div class="mt-5">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div class="d-flex align-items-center gap-3">
                                <h2 class="h5 fw-semibold mb-0">Driver's License</h2>
                                <span class="badge verification-failed px-3 py-1">
                                    <i class="bi bi-exclamation-triangle me-1"></i>Verification failed
                                </span>
                            </div>
                            <button class="btn btn-outline-secondary btn-sm">
                                <i class="bi bi-pencil me-1"></i>Edit
                            </button>
                        </div>

                        <div class="row g-5">
                            <div class="col-md-4">
                                <h6 class="text-muted mb-3">Image</h6>
                                <div class="upload-area p-5 text-center">
                                    <div class="upload-icon rounded-circle d-flex align-items-center justify-content-center mx-auto mb-3">
                                        <i class="bi bi-upload"></i>
                                    </div>
                                    <p class="text-muted mb-0">Click to upload</p>
                                </div>
                            </div>

                            <div class="col-md-8">
                                <h6 class="text-muted mb-4">General Information</h6>
                                
                                <div class="mb-4">
                                    <label class="form-label text-muted">Driver's License Number</label>
                                    <input type="text" class="form-control" placeholder="">
                                </div>

                                <div class="mb-4">
                                    <label class="form-label text-muted">Full name</label>
                                    <input type="text" class="form-control" placeholder="">
                                </div>

                                <div class="mb-4">
                                    <label class="form-label text-muted">Date of birth</label>
                                    <input type="date" class="form-control" placeholder="">
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
</body>
</html>
