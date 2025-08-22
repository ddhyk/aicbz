<template>
  <div class="home">
    <!-- Back to top button -->
    <BackToTop />
    
    <!-- Header Section -->
    <Header />
    
    <!-- Banner Section -->
    <Banner />
    
    <!-- Under Development Section -->
    <section class="under-development py-5">
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-md-8 text-center">
            <div class="development-card">
              <div class="development-icon mb-4">
                <i class="fas fa-code fa-4x"></i>
              </div>
              <h2 class="development-title mb-3">功能开发中</h2>
              <p class="development-text mb-4">
                我们正在努力完善更多功能，为您提供更好的简历优化体验。
                <br>
                敬请期待！
              </p>
              <div class="development-features">
                <div class="row">
                  <div class="col-md-4 mb-3">
                    <div class="feature-item">
                      <i class="fas fa-chart-line mb-2"></i>
                      <p>数据分析</p>
                    </div>
                  </div>
                  <div class="col-md-4 mb-3">
                    <div class="feature-item">
                      <i class="fas fa-users mb-2"></i>
                      <p>用户社区</p>
                    </div>
                  </div>
                  <div class="col-md-4 mb-3">
                    <div class="feature-item">
                      <i class="fas fa-mobile-alt mb-2"></i>
                      <p>移动应用</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    
    <!-- Footer Section -->
    <Footer />
  </div>
</template>

<script>
import BackToTop from '../components/BackToTop.vue'
import Header from '../components/Header.vue'
import Banner from '../components/Banner.vue'
import Footer from '../components/Footer.vue'

export default {
  name: 'Home',
  components: {
    BackToTop,
    Header,
    Banner,
    Footer
  }
}
</script>

<style scoped>
/* Home specific styles */
.under-development {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  min-height: 60vh;
  display: flex;
  align-items: center;
}

.development-card {
  background: white;
  border-radius: 20px;
  padding: 3rem 2rem;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  border: 1px solid #e9ecef;
  transition: all 0.3s ease;
}

.development-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 20px 40px rgba(102, 126, 234, 0.15);
}

.development-icon {
  color: #667eea;
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.05); }
  100% { transform: scale(1); }
}

.development-title {
  color: #2c3e50;
  font-weight: 700;
  font-size: 2.5rem;
}

.development-text {
  color: #6c757d;
  font-size: 1.1rem;
  line-height: 1.6;
}

.development-features {
  margin-top: 2rem;
}

.feature-item {
  padding: 1.5rem;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border-radius: 15px;
  border: 1px solid #e9ecef;
  transition: all 0.3s ease;
  height: 100%;
}

.feature-item:hover {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  transform: translateY(-3px);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
}

.feature-item i {
  font-size: 2rem;
  color: #667eea;
  transition: color 0.3s ease;
}

.feature-item:hover i {
  color: white;
}

.feature-item p {
  margin: 0;
  font-weight: 600;
  font-size: 1rem;
}

@media (max-width: 768px) {
  .development-title {
    font-size: 2rem;
  }
  
  .development-card {
    padding: 2rem 1.5rem;
  }
  
  .development-icon {
    font-size: 3rem;
  }
}
</style>