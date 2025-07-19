<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.UUID" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String carId = request.getParameter("carId");
    String carModel = request.getParameter("carModel");
    List<Model.Entity.Car.CarFeature> allFeatures = (List<Model.Entity.Car.CarFeature>) request.getAttribute("allFeatures");
    List<UUID> selectedFeatures = (List<UUID>) request.getAttribute("selectedFeatures");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chọn tính năng xe</title>
    <style>
        body { background: #f4f6f8; margin: 0; font-family: 'Inter', Arial, sans-serif; }
        .modal-bg { min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        .modal-content {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.18);
            width: 95%;
            max-width: 420px;
            padding: 0 0 24px 0;
            animation: fadeIn 0.3s;
        }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-20px);} to { opacity: 1; transform: none; } }
        .modal-header {
            background: linear-gradient(90deg, #01d28e 0%, #00b8d9 100%);
            border-radius: 14px 14px 0 0;
            padding: 20px 24px 16px 24px;
            color: #fff;
            text-align: center;
        }
        .modal-header h2 { margin: 0; font-size: 22px; font-weight: 700; letter-spacing: 0.5px; }
        .feature-list { max-height: 320px; overflow-y: auto; padding: 18px 24px 0 24px; }
        .feature-item { margin-bottom: 12px; }
        .feature-checkbox {
            accent-color: #01d28e;
            width: 18px; height: 18px;
            margin-right: 10px;
            vertical-align: middle;
        }
        .feature-label { font-size: 15px; color: #222; font-weight: 500; cursor: pointer; }
        .btn {
            padding: 10px 22px;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 18px;
            transition: background 0.2s;
        }
        .btn-primary { background: #01d28e; color: #fff; margin-right: 10px; }
        .btn-primary:hover { background: #00b8d9; }
        .btn-secondary { background: #e9ecef; color: #333; }
        .btn-secondary:hover { background: #d1d5db; }
        @media (max-width: 600px) {
            .modal-content { max-width: 99vw; padding: 0; }
            .feature-list { padding: 14px 8px 0 8px; }
        }
    </style>
</head>
<body>
<div class="modal-bg">
    <div class="modal-content">
        <div class="modal-header">
            <h2>Chọn tính năng cho xe<br><span style="font-size:15px;font-weight:400;">(<%= carModel != null ? carModel : "" %>)</span></h2>
        </div>
        <form id="featureForm" method="post" action="<%= request.getContextPath() %>/FeatureCarServlet">
            <input type="hidden" name="carId" value="<%= carId %>" />
            <div class="feature-list">
                <%-- Danh sách 18 tính năng mặc định --%>
                <%
                String[][] defaultFeatures = {
                    {"11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa", "Map"},
                    {"22222222-aaaa-aaaa-aaaa-aaaaaaaaaaaa", "Bluetooth"},
                    {"33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa", "360 Camera"},
                    {"44444444-aaaa-aaaa-aaaa-aaaaaaaaaaaa", "Side Camera"},
                    {"55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa", "Dash Cam"},
                    {"66666666-aaaa-aaaa-aaaa-aaaaaaaaaaaa", "Rearview Camera"},
                    {"77777777-aaaa-aaaa-aaaa-aaaaaaaaaaaa", "Tire Pressure Sensor"},
                    {"88888888-aaaa-aaaa-aaaa-aaaaaaaaaaaa", "Collision Sensor"},
                    {"99999999-aaaa-aaaa-aaaa-aaaaaaaaaaaa", "Speed Warning"},
                    {"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa", "Sunroof"},
                    {"bbbbbbbb-aaaa-aaaa-aaaa-aaaaaaaaaaaa", "GPS Navigation"},
                    {"cccccccc-aaaa-aaaa-aaaa-aaaaaaaaaaaa", "ETC"},
                    {"dddddddd-aaaa-aaaa-aaaa-aaaaaaaaaaaa", "Child Seat"},
                    {"eeeeeeee-aaaa-aaaa-aaaa-aaaaaaaaaaaa", "USB Port"},
                    {"ffffffff-aaaa-aaaa-aaaa-aaaaaaaaaaaa", "Spare Tire"},
                    {"11111111-bbbb-bbbb-bbbb-bbbbbbbbbbbb", "DVD Screen"},
                    {"22222222-bbbb-bbbb-bbbb-bbbbbbbbbbbb", "Pickup Truck Bed Cover"},
                    {"33333333-bbbb-bbbb-bbbb-bbbbbbbbbbbb", "Airbag"}
                };
                List<UUID> selected = selectedFeatures != null ? selectedFeatures : new java.util.ArrayList<>();
                for (String[] feat : defaultFeatures) {
                    String fid = feat[0];
                    String fname = feat[1];
                %>
                <div class="feature-item">
                    <label class="feature-label">
                        <input type="checkbox" class="feature-checkbox" name="featureId" value="<%= fid %>"
                            <%= selected.contains(java.util.UUID.fromString(fid)) ? "checked" : "" %>
                        />
                        <%= fname %>
                    </label>
                </div>
                <% } %>
            </div>
            <div style="text-align:center;">
                <button type="submit" class="btn btn-primary">Lưu tính năng</button>
                <a href="<%= request.getContextPath() %>/manageCarsServlet" class="btn btn-secondary">Quay lại</a>
            </div>
        </form>
    </div>
</div>
</body>
</html> 