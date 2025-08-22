<template>
  <footer class="footer-con">
    <div class="middle_portion">
      <div class="container">
        <div class="row">
          <div class="col-lg-3 col-md-6 col-sm-6 col-12">
            <div class="logo-content">
              <div class="footer-logo">
                <figure class="mb-0">
                  <img src="../assets/images/footer-logo.png" alt="footer-logo" class="img-fluid">
                </figure>
              </div>
              <p>Transform your career with AI-powered resume optimization. Get noticed by employers and land your dream job.</p>
              <ul class="social-icons list-unstyled mb-0">
                <li>
                  <a href="#" class="text-decoration-none">
                    <i class="fab fa-facebook-f"></i>
                  </a>
                </li>
                <li>
                  <a href="#" class="text-decoration-none">
                    <i class="fab fa-twitter"></i>
                  </a>
                </li>
                <li>
                  <a href="#" class="text-decoration-none">
                    <i class="fab fa-linkedin-in"></i>
                  </a>
                </li>
                <li>
                  <a href="#" class="text-decoration-none">
                    <i class="fab fa-instagram"></i>
                  </a>
                </li>
              </ul>
            </div>
          </div>
          <div class="col-lg-3 col-md-6 col-sm-6 col-12">
            <div class="links">
              <h4>Quick Links</h4>
              <ul class="list-unstyled mb-0">
                <li>
                  <i class="fas fa-angle-right"></i>
                  <a href="#home" class="text-decoration-none">Home</a>
                </li>
                <li>
                  <i class="fas fa-angle-right"></i>
                  <a href="#about-con" class="text-decoration-none">About</a>
                </li>
                <li>
                  <i class="fas fa-angle-right"></i>
                  <a href="#our-services-con" class="text-decoration-none">Services</a>
                </li>
                <li>
                  <i class="fas fa-angle-right"></i>
                  <a href="#pricing-plans-con" class="text-decoration-none">Pricing</a>
                </li>
                <li>
                  <i class="fas fa-angle-right"></i>
                  <a href="#faq-con" class="text-decoration-none">FAQ</a>
                </li>
              </ul>
            </div>
          </div>
          <div class="col-lg-3 col-md-6 col-sm-6 col-12">
            <div class="icon">
              <h4>Contact Info</h4>
              <ul class="list-unstyled mb-0">
                <li>
                  <i class="fas fa-map-marker-alt"></i>
                  <a href="#" class="text-decoration-none">123 Business Ave, Suite 100<br>New York, NY 10001</a>
                </li>
                <li>
                  <i class="fas fa-phone-alt"></i>
                  <a href="tel:+1234567890" class="text-decoration-none">+1 (234) 567-8900</a>
                </li>
                <li>
                  <i class="fas fa-envelope"></i>
                  <a href="mailto:support@resumeai.com" class="text-decoration-none">support@resumeai.com</a>
                </li>
              </ul>
            </div>
          </div>
          <div class="col-lg-3 col-md-6 col-sm-6 col-12">
            <div class="email-form">
              <h4>Newsletter</h4>
              <form @submit.prevent="subscribeNewsletter">
                <div class="form-group position-relative">
                  <input 
                    type="email" 
                    v-model="email" 
                    placeholder="Enter your email" 
                    required
                    class="form-control"
                  >
                  <button type="submit" class="btn">
                    <i class="fas fa-paper-plane"></i>
                  </button>
                </div>
                <div class="check-box">
                  <input type="checkbox" id="newsletter-checkbox" v-model="agreeToTerms" required>
                  <label for="newsletter-checkbox">
                    I agree to the <a href="#" class="text-decoration-none">Privacy Policy</a> and <a href="#" class="text-decoration-none">Terms of Service</a>
                  </label>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="copyright">
      <div class="container">
        <div class="row">
          <div class="col-12">
            <p class="mb-0">© {{ currentYear }} Resume AI Optimizer. All rights reserved. | Designed with ❤️ for career success</p>
          </div>
        </div>
      </div>
    </div>
  </footer>
</template>

<script>
export default {
  name: 'Footer',
  data() {
    return {
      email: '',
      agreeToTerms: false,
      currentYear: new Date().getFullYear()
    }
  },
  methods: {
    subscribeNewsletter() {
      if (this.email && this.agreeToTerms) {
        // Handle newsletter subscription
        console.log('Subscribing email:', this.email);
        // Here you would typically send the email to your backend
        alert('Thank you for subscribing to our newsletter!');
        this.email = '';
        this.agreeToTerms = false;
      }
    }
  },
  mounted() {
    // Add smooth scrolling for footer links
    const links = this.$el.querySelectorAll('a[href^="#"]');
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
  }
}
</script>

<style scoped>
/* Footer specific styles are in the main CSS file */
</style>