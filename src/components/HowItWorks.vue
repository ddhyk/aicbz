<template>
  <section class="our-work-con padding-top padding-bottom" id="our-work-con">
    <div class="container">
      <div class="row">
        <div class="col-12">
          <div class="our-work_content">
            <div class="heading-title-con text-center" data-aos="fade-up">
              <div class="special-text">How It Works</div>
              <h2>Simple Steps to <span class="color-blue">Optimize</span> Your Resume</h2>
              <p class="text-size-18">Get your resume optimized in just three easy steps with our AI-powered platform.</p>
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-lg-4 col-md-4 col-sm-12 col-12">
          <div class="work-box" data-aos="fade-up">
            <figure class="work-icon">
              <img src="../assets/images/work-icon1.png" alt="work-icon1" class="img-fluid">
            </figure>
            <div class="work-number">01</div>
            <h4>Upload Your Resume</h4>
            <p class="text-size-16">Simply upload your current resume in PDF or Word format. Our system supports all major file types.</p>
          </div>
        </div>
        <div class="col-lg-4 col-md-4 col-sm-12 col-12">
          <div class="work-box" data-aos="fade-up" data-aos-delay="100">
            <figure class="work-icon">
              <img src="../assets/images/work-icon2.png" alt="work-icon2" class="img-fluid">
            </figure>
            <div class="work-number">02</div>
            <h4>AI Analysis & Optimization</h4>
            <p class="text-size-16">Our advanced AI analyzes your resume content, structure, and keywords to provide personalized recommendations.</p>
          </div>
        </div>
        <div class="col-lg-4 col-md-4 col-sm-12 col-12">
          <div class="work-box" data-aos="fade-up" data-aos-delay="200">
            <figure class="work-icon">
              <img src="../assets/images/work-icon3.png" alt="work-icon3" class="img-fluid">
            </figure>
            <div class="work-number">03</div>
            <h4>Download Optimized Resume</h4>
            <p class="text-size-16">Get your professionally optimized resume ready for job applications with improved ATS compatibility.</p>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-12">
          <div class="work-btn text-center" data-aos="fade-up">
            <a href="#build-con" class="primary_btn">Get Started Now</a>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'HowItWorks',
  mounted() {
    // Initialize AOS animations if available
    if (typeof AOS !== 'undefined') {
      AOS.init();
    }
  }
}
</script>

<style scoped>
/* How It Works specific styles are in the main CSS file */
</style>