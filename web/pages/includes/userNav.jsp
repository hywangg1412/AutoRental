<nav class="navbar navbar-expand-lg bg-white" id="ftco-navbar" style="width:100%;margin:0;border-bottom:1px solid #e0e0e0;">
  <div class="container">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/pages/index.jsp">
      <span style="font-weight:bold; color:#000;">AUTO</span><span style="font-weight:bold; color:#01D28E;">RENTAL</span>
    </a>
    <button class="navbar-toggler text-dark" type="button" data-toggle="collapse" data-target="#ftco-nav" aria-controls="ftco-nav"
      aria-expanded="false" aria-label="Toggle navigation">
      <span class="oi oi-menu"></span> Menu
    </button>

    
      <div class="collapse navbar-collapse" id="ftco-nav">
        <ul class="navbar-nav ml-auto">
          <li class="nav-item"><a href="about.jsp" class="nav-link text-dark">About</a></li>
          <li class="nav-item"><a href="my-trip.jsp" class="nav-link text-dark">My trips</a></li>
        </ul>
        <div class="d-flex align-items-center ms-3 gap-3">
          <a href="#" class="nav-link p-0 text-dark"><i class="bi bi-bell text-dark" style="font-size: 1.2rem;"></i></a>
          <a href="#" class="nav-link p-0 text-dark"><i class="bi bi-chat-dots text-dark" style="font-size: 1.2rem;"></i></a>
          <div class="d-flex align-items-center gap-2 ms-2">
            <img src="${not empty sessionScope.user.avatarUrl ? sessionScope.user.avatarUrl : pageContext.request.contextPath.concat('/assets/images/default-avatar.png')}" 
                 alt="avatar" 
                 style="width:32px;height:32px;object-fit:cover;border-radius:50%;display:inline-block;"
                 onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-avatar.png';">
            <a href="UserAbout.jsp" class="text-dark" style="font-weight:500; text-decoration: none;">
              ${sessionScope.user.username}
            </a>
            <i class="bi bi-caret-down-fill text-dark" style="font-size:0.9rem;"></i>
          </div>
        </div>
      </div>
    
    </div>
</nav>