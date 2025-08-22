<template>
  <section class="float-left w-100 banner-con position-relative main-box">
    <div class="container">
      <div class="row align-items-center">
        <div class="col-lg-7 col-md-7">
          <div class="banner-content-con" style="margin-left: 60px;">
              <h1>AI 赋能，<br>
                为你的求职之路<br>
                <span class="d-inline-block font-weight-bold color-blue">精准导航！</span></h1>
              <p>专业的AI简历优化助手，助力你在求职路上脱颖而出。</p>
              <a href="#" class="text-decoration-none primary_btn d-inline-block" @click.prevent="getStarted">开始使用</a>
              <a href="#" class="text-decoration-none secondary_btn d-inline-block" @click.prevent="liveDemo">在线体验</a>
          </div>
        </div>
        <div class="col-lg-5 col-md-5">
          <div class="banner-img-con position-relative">
            <figure><img src="../assets/images/banner-robot.png" alt="robot" class="animated-robot"></figure>
            <div class="coment-box1 d-flex align-items-center popup-bubble popup-delay-1">
              <img src="../assets/images/coment-box-icon1.png" alt="icon" class="img-fluid">
              <p class="typing mb-0" id="text1"></p>
            </div>
            <div class="coment-box2 d-flex align-items-center popup-bubble popup-delay-2">
              <img src="../assets/images/coment-box-icon2.png" alt="icon" class="img-fluid">
              <p class="typing mb-0" id="text2"></p>
            </div>
          </div>
        </div>
      </div>
      <div class="down_button text-center d-inline-block">
        <a href="#client" class="scroll text-decoration-none">
          <figure class="banner-dropdownimage mb-0 d-inline-block">
            <img src="../assets/images/banner-dropdownimage.png" class="img-fluid" alt="image">
          </figure>
        </a>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'Banner',
  mounted() {
    this.initTypingEffect()
  },
  methods: {
    getStarted() {
      console.log('Get Started clicked')
    },
    liveDemo() {
      console.log('Live Demo clicked')
    },
    typeText(text, element, delayBetweenLetters = 50, callback = null) {
      let index = 0
      
      const type = () => {
        if (index < text.length) {
          element.innerHTML += text.charAt(index)
          index++
          setTimeout(type, delayBetweenLetters)
        } else if (callback) {
          setTimeout(callback, 100)
        }
      }
      type()
    },
    initTypingEffect() {
      const text1 = "嗨，我们能为您做些什么？"
      const text2 = "你能帮我针对岗位要求丰富一下简历嘛？"
      const element1 = document.getElementById("text1")
      const element2 = document.getElementById("text2")
      
      if (element1 && element2) {
        this.typeText(text1, element1, 100, () => {
          setTimeout(() => {
            this.typeText(text2, element2, 80)
          }, 500)
        })
      } else {
        console.warn("One or both elements not found: #text1 or #text2")
      }
    }
  }
}
</script>

<style scoped>
/* Banner specific styles are in the main CSS file */
</style>