<template>
  <div class="header-con">
    <div class="container">
      <nav class="navbar navbar-expand-lg navbar-light">
        <a class="navbar-brand" href="#">
          <figure class="mb-0">
            <img src="../assets/images/logo.png" alt="logo" class="img-fluid">
          </figure>
        </a>
        <button class="navbar-toggler collapsed" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
          <span class="navbar-toggler-icon"></span>
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <ul class="navbar-nav mx-auto">
            <li class="nav-item active">
              <router-link class="nav-link" to="/">首页</router-link>
            </li>
            <li class="nav-item">
              <router-link class="nav-link" to="/resume-optimizer">AI优化简历</router-link>
            </li>
            <li class="nav-item">
              <router-link class="nav-link" to="/jobs">职位市场</router-link>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#referral">大厂内推</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#interview-tips">面试技巧</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#profile">个人中心</a>
            </li>
          </ul>
        </div>
      </nav>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Header',
  mounted() {
    // Add smooth scrolling functionality
    const links = document.querySelectorAll('a[href^="#"]');
    links.forEach(link => {
      link.addEventListener('click', (e) => {
        e.preventDefault();
        const targetId = link.getAttribute('href').substring(1);
        const targetElement = document.getElementById(targetId);
        if (targetElement) {
          targetElement.scrollIntoView({ behavior: 'smooth' });
        }
      });
    });

    // Add navbar toggle functionality
    const navbarToggler = document.querySelector('.navbar-toggler');
    const navbarCollapse = document.querySelector('.navbar-collapse');
    
    if (navbarToggler && navbarCollapse) {
      navbarToggler.addEventListener('click', () => {
        navbarCollapse.classList.toggle('show');
        navbarToggler.classList.toggle('collapsed');
      });
    }
  }
}
</script>

<style scoped>
/* Header specific styles are in the main CSS file */
</style>