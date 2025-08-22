<template>
  <section class="pricing-plans-con padding-top padding-bottom" id="pricing-plans-con">
    <div class="container">
      <div class="row">
        <div class="col-12">
          <div class="pricing-plans_content">
            <div class="heading-title-con text-center" data-aos="fade-up">
              <div class="special-text">Pricing Plans</div>
              <h2>Choose the Perfect <span class="color-blue">Plan</span> for You</h2>
              <p class="text-size-18">Select from our flexible pricing options designed to meet your career advancement needs.</p>
            </div>
          </div>
        </div>
      </div>
      <div class="row" data-aos="fade-up">
        <div class="col-lg-4 col-md-6 col-sm-6 col-12">
          <div class="pricing-box">
            <div class="pricing-header">
              <h4>Basic</h4>
              <div class="pricing-price">
                <span class="currency">$</span>
                <span class="price">9</span>
                <span class="period">/month</span>
              </div>
            </div>
            <div class="pricing-features">
              <ul>
                <li><i class="fas fa-check"></i>1 Resume Optimization</li>
                <li><i class="fas fa-check"></i>Basic AI Analysis</li>
                <li><i class="fas fa-check"></i>ATS Compatibility Check</li>
                <li><i class="fas fa-check"></i>Email Support</li>
                <li class="disabled"><i class="fas fa-times"></i>Industry-Specific Templates</li>
                <li class="disabled"><i class="fas fa-times"></i>Priority Support</li>
              </ul>
            </div>
            <div class="pricing-btn">
              <a href="#build-con" class="secondary_btn">Get Started</a>
            </div>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 col-sm-6 col-12">
          <div class="pricing-box featured">
            <div class="popular-badge">Most Popular</div>
            <div class="pricing-header">
              <h4>Professional</h4>
              <div class="pricing-price">
                <span class="currency">$</span>
                <span class="price">19</span>
                <span class="period">/month</span>
              </div>
            </div>
            <div class="pricing-features">
              <ul>
                <li><i class="fas fa-check"></i>5 Resume Optimizations</li>
                <li><i class="fas fa-check"></i>Advanced AI Analysis</li>
                <li><i class="fas fa-check"></i>ATS Compatibility Check</li>
                <li><i class="fas fa-check"></i>Industry-Specific Templates</li>
                <li><i class="fas fa-check"></i>Cover Letter Optimization</li>
                <li><i class="fas fa-check"></i>Priority Support</li>
              </ul>
            </div>
            <div class="pricing-btn">
              <a href="#build-con" class="primary_btn">Get Started</a>
            </div>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 col-sm-6 col-12">
          <div class="pricing-box">
            <div class="pricing-header">
              <h4>Enterprise</h4>
              <div class="pricing-price">
                <span class="currency">$</span>
                <span class="price">39</span>
                <span class="period">/month</span>
              </div>
            </div>
            <div class="pricing-features">
              <ul>
                <li><i class="fas fa-check"></i>Unlimited Optimizations</li>
                <li><i class="fas fa-check"></i>Premium AI Analysis</li>
                <li><i class="fas fa-check"></i>ATS Compatibility Check</li>
                <li><i class="fas fa-check"></i>All Premium Templates</li>
                <li><i class="fas fa-check"></i>LinkedIn Profile Optimization</li>
                <li><i class="fas fa-check"></i>24/7 Priority Support</li>
              </ul>
            </div>
            <div class="pricing-btn">
              <a href="#build-con" class="secondary_btn">Get Started</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'Pricing',
  mounted() {
    // Initialize AOS animations if available
    if (typeof AOS !== 'undefined') {
      AOS.init();
    }
  }
}
</script>

<style scoped>
/* Pricing specific styles are in the main CSS file */
</style>