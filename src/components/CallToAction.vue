<template>
  <section class="build-con padding-top padding-bottom" id="build-con">
    <div class="container">
      <div class="row">
        <div class="col-12">
          <div class="build_content text-center" data-aos="fade-up">
            <div class="special-text">Ready to Get Started?</div>
            <h2>Transform Your Resume <span class="color-blue">Today</span></h2>
            <p class="text-size-18">Join thousands of professionals who have successfully optimized their resumes with our AI-powered platform. Start your journey to career success now.</p>
            <div class="build-btn">
              <a href="#" class="primary_btn" @click="startOptimization">Start Free Trial</a>
              <a href="#our-services-con" class="secondary_btn">Learn More</a>
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-12">
          <div class="build-stats" data-aos="fade-up" data-aos-delay="200">
            <div class="row">
              <div class="col-lg-3 col-md-6 col-sm-6 col-12">
                <div class="stat-box">
                  <div class="stat-number">50K+</div>
                  <div class="stat-label">Resumes Optimized</div>
                </div>
              </div>
              <div class="col-lg-3 col-md-6 col-sm-6 col-12">
                <div class="stat-box">
                  <div class="stat-number">95%</div>
                  <div class="stat-label">Success Rate</div>
                </div>
              </div>
              <div class="col-lg-3 col-md-6 col-sm-6 col-12">
                <div class="stat-box">
                  <div class="stat-number">24/7</div>
                  <div class="stat-label">Support Available</div>
                </div>
              </div>
              <div class="col-lg-3 col-md-6 col-sm-6 col-12">
                <div class="stat-box">
                  <div class="stat-number">30 Day</div>
                  <div class="stat-label">Money Back Guarantee</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'CallToAction',
  methods: {
    startOptimization() {
      // Handle start optimization action
      // This could redirect to a signup page or open a modal
      console.log('Starting optimization process...');
      // Example: this.$router.push('/signup');
    }
  },
  mounted() {
    // Initialize AOS animations if available
    if (typeof AOS !== 'undefined') {
      AOS.init();
    }
  }
}
</script>

<style scoped>
/* Call to Action specific styles are in the main CSS file */
</style>