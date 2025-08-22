<template>
  <section class="float-left w-100 position-relative why-choose-us-con padding-top padding-bottom main-box">
    <div class="container wow fadeInUp" data-wow-duration="2s" data-wow-delay="0.2s">
      <div class="heading-title-con text-center">
        <span class="special-text color-blue d-block wow fadeInLeft" data-wow-duration="2s" data-wow-delay="0.2s">Why Choose Us</span>
        <h2 class="wow fadeInRight" data-wow-duration="2s" data-wow-delay="0.4s">Unique Selling Points & Advantages <br>
        of Our Service</h2>
      </div>
      <div class="choose-outer-con wow fadeInDown" data-wow-duration="2s" data-wow-delay="0.5s">
        <div class="choose-box">
          <figure><img src="../assets/images/choose-icon1.png" alt="icon" class="img-fluid"></figure>
          <h6>Tailored Solutions</h6>
          <p class="mb-0">We offer customized
            services designed to meet
            the specific needs...</p>
        </div>
        <div class="choose-box">
          <figure><img src="../assets/images/choose-icon2.png" alt="icon" class="img-fluid"></figure>
          <h6>Customer Support</h6>
          <p class="mb-0">Our dedicated support
            team is available 24/7,
            providing assistance...</p>
        </div>
        <div class="choose-box">
          <figure><img src="../assets/images/choose-icon3.png" alt="icon" class="img-fluid"></figure>
          <h6>Affordable Pricing</h6>
          <p class="mb-0">Competitive rates with
            transparent pricing—no
            hidden fees...
          </p>
        </div>
        <div class="choose-box">
          <figure><img src="../assets/images/choose-icon4.png" alt="icon" class="img-fluid"></figure>
          <h6>Scalable Solutions</h6>
          <p class="mb-0">Our services grow with
            your business, allowing
            you to scale up...</p>
        </div>
        <div class="choose-box">
          <figure><img src="../assets/images/choose-icon5.png" alt="icon" class="img-fluid"></figure>
          <h6>Expert Team</h6>
          <p class="mb-0">Our experienced
            professionals bring deep
            industry knowledge...</p>
        </div>
      </div>
      <div class="float-left w-100 m-auto text-center wow fadeInUp" data-wow-duration="2s" data-wow-delay="0.4s">
        <a href="#" class="text-decoration-none primary_btn d-inline-block" @click.prevent="getStarted">Get
          Started</a>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'WhyChooseUs',
  methods: {
    getStarted() {
      // 可以添加跳转到注册页面或其他操作的逻辑
      console.log('Get Started clicked')
    }
  }
}
</script>

<style scoped>
/* Why Choose Us specific styles are in the main CSS file */
</style>