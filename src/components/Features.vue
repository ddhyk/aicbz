<template>
  <section class="our-services-con padding-top padding-bottom" id="our-services-con">
    <div class="container">
      <div class="row">
        <div class="col-12">
          <div class="our-services_content">
            <div class="heading-title-con text-center" data-aos="fade-up">
              <div class="special-text">Amazing Features</div>
              <h2>Powerful AI-Driven Resume <span class="color-blue">Optimization</span></h2>
              <p class="text-size-18">Our advanced AI technology analyzes your resume and provides personalized recommendations to help you land your dream job.</p>
            </div>
          </div>
        </div>
      </div>
      <div class="row" data-aos="fade-up">
        <div class="col-lg-4 col-md-6 col-sm-6 col-12">
          <div class="service-box">
            <figure class="service-icon">
              <img src="../assets/images/service-icon1.png" alt="service-icon1" class="img-fluid">
            </figure>
            <h4>AI Content Analysis</h4>
            <p class="text-size-16">Advanced algorithms analyze your resume content and suggest improvements for better impact and readability.</p>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 col-sm-6 col-12">
          <div class="service-box">
            <figure class="service-icon">
              <img src="../assets/images/service-icon2.png" alt="service-icon2" class="img-fluid">
            </figure>
            <h4>Industry Optimization</h4>
            <p class="text-size-16">Tailored recommendations based on your target industry and role requirements for maximum relevance.</p>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 col-sm-6 col-12">
          <div class="service-box">
            <figure class="service-icon">
              <img src="../assets/images/service-icon3.png" alt="service-icon3" class="img-fluid">
            </figure>
            <h4>ATS Compatibility</h4>
            <p class="text-size-16">Ensure your resume passes through Applicant Tracking Systems with optimized formatting and keywords.</p>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 col-sm-6 col-12">
          <div class="service-box">
            <figure class="service-icon">
              <img src="../assets/images/service-icon4.png" alt="service-icon4" class="img-fluid">
            </figure>
            <h4>Real-time Feedback</h4>
            <p class="text-size-16">Get instant suggestions and improvements as you edit your resume with our live optimization engine.</p>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 col-sm-6 col-12">
          <div class="service-box">
            <figure class="service-icon">
              <img src="../assets/images/service-icon5.png" alt="service-icon5" class="img-fluid">
            </figure>
            <h4>Professional Templates</h4>
            <p class="text-size-16">Choose from a variety of professionally designed templates that are both attractive and ATS-friendly.</p>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 col-sm-6 col-12">
          <div class="service-box">
            <figure class="service-icon">
              <img src="../assets/images/service-icon6.png" alt="service-icon6" class="img-fluid">
            </figure>
            <h4>Performance Analytics</h4>
            <p class="text-size-16">Track your resume's performance with detailed analytics and insights to continuously improve your job search.</p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'Features',
  mounted() {
    // Initialize AOS animations if available
    if (typeof AOS !== 'undefined') {
      AOS.init();
    }
  }
}
</script>

<style scoped>
/* Features specific styles are in the main CSS file */
</style>