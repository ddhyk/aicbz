<template>
  <section class="testimonial-con padding-top padding-bottom" id="testimonial-con">
    <div class="container">
      <div class="row">
        <div class="col-12">
          <div class="testimonial_content">
            <div class="heading-title-con text-center" data-aos="fade-up">
              <div class="special-text">Testimonials</div>
              <h2>What Our <span class="color-blue">Clients</span> Say</h2>
              <p class="text-size-18">Hear from professionals who have successfully transformed their careers with our AI-powered resume optimization.</p>
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-12">
          <div class="testimonial-slider" data-aos="fade-up">
            <div class="testimonial-wrapper">
              <div class="testimonial-box active">
                <div class="testimonial-content">
                  <div class="testimonial-rating">
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                  </div>
                  <p class="text-size-16">"The AI-powered optimization completely transformed my resume. I went from getting no responses to landing 3 interviews in just one week. The suggestions were spot-on and really helped me highlight my strengths."</p>
                  <div class="testimonial-author">
                    <figure class="testimonial-img">
                      <img src="../assets/images/testimonial-img1.png" alt="testimonial-img1" class="img-fluid">
                    </figure>
                    <div class="author-info">
                      <h5>Sarah Johnson</h5>
                      <span class="text-size-14">Marketing Manager</span>
                    </div>
                  </div>
                </div>
              </div>
              <div class="testimonial-box">
                <div class="testimonial-content">
                  <div class="testimonial-rating">
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                  </div>
                  <p class="text-size-16">"As a software engineer, I was struggling to get past ATS systems. This platform not only optimized my resume for ATS but also made it more compelling. I got my dream job at a Fortune 500 company!"</p>
                  <div class="testimonial-author">
                    <figure class="testimonial-img">
                      <img src="../assets/images/testimonial-img2.png" alt="testimonial-img2" class="img-fluid">
                    </figure>
                    <div class="author-info">
                      <h5>Michael Chen</h5>
                      <span class="text-size-14">Software Engineer</span>
                    </div>
                  </div>
                </div>
              </div>
              <div class="testimonial-box">
                <div class="testimonial-content">
                  <div class="testimonial-rating">
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                  </div>
                  <p class="text-size-16">"The industry-specific optimization was incredible. The AI understood my field and suggested improvements that I never would have thought of. My resume now perfectly showcases my expertise."</p>
                  <div class="testimonial-author">
                    <figure class="testimonial-img">
                      <img src="../assets/images/testimonial-img3.png" alt="testimonial-img3" class="img-fluid">
                    </figure>
                    <div class="author-info">
                      <h5>Emily Rodriguez</h5>
                      <span class="text-size-14">Financial Analyst</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="testimonial-navigation">
              <button class="testimonial-prev" @click="previousTestimonial">
                <i class="fas fa-chevron-left"></i>
              </button>
              <button class="testimonial-next" @click="nextTestimonial">
                <i class="fas fa-chevron-right"></i>
              </button>
            </div>
            <div class="testimonial-dots">
              <span class="dot active" @click="currentTestimonial(0)"></span>
              <span class="dot" @click="currentTestimonial(1)"></span>
              <span class="dot" @click="currentTestimonial(2)"></span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'Testimonials',
  data() {
    return {
      currentSlide: 0,
      totalSlides: 3
    }
  },
  methods: {
    nextTestimonial() {
      this.currentSlide = (this.currentSlide + 1) % this.totalSlides;
      this.updateSlider();
    },
    previousTestimonial() {
      this.currentSlide = (this.currentSlide - 1 + this.totalSlides) % this.totalSlides;
      this.updateSlider();
    },
    currentTestimonial(index) {
      this.currentSlide = index;
      this.updateSlider();
    },
    updateSlider() {
      const testimonialBoxes = document.querySelectorAll('.testimonial-box');
      const dots = document.querySelectorAll('.dot');
      
      testimonialBoxes.forEach((box, index) => {
        box.classList.remove('active');
        if (index === this.currentSlide) {
          box.classList.add('active');
        }
      });
      
      dots.forEach((dot, index) => {
        dot.classList.remove('active');
        if (index === this.currentSlide) {
          dot.classList.add('active');
        }
      });
    }
  },
  mounted() {
    // Initialize AOS animations if available
    if (typeof AOS !== 'undefined') {
      AOS.init();
    }
    
    // Auto-slide functionality
    setInterval(() => {
      this.nextTestimonial();
    }, 5000);
  }
}
</script>

<style scoped>
/* Testimonials specific styles are in the main CSS file */
</style>