import { AdvertClass } from '../../models'
import { UserSettingClass } from '../../utils'
import router from '@ohos.router'

@Entry
@Component
struct Start {
  userSetting:UserSettingClass = new UserSettingClass(getContext(this))
  @State adObj: AdvertClass | null = null
  timer:number = 0  // 记录计时器

  async aboutToAppear(): Promise<void> {
    // 从首选项中获取广告数据
    this.adObj = await this.userSetting.getUserAd()
    // 实现广告倒计时
    this.timer = setInterval(()=>{
      if (this.adObj!.adTime === 0) {
        router.replaceUrl({url:"pages/Index"})
        clearInterval(this.timer)
        return
      }
      this.adObj!.adTime--
    },1000)
  }

  build() {
    Stack({alignContent:Alignment.TopEnd}) {
      Image(this.adObj?.adImg).objectFit(ImageFit.Cover)
      Text(`${this.adObj?.adTime} S后跳转`)
        .backgroundColor($r('app.color.background_page'))
        .padding({left:10,right:10})
        .margin({right:20,top:20})
        .height(30)
        .fontSize(14)
        .borderRadius(15)
        .textAlign(TextAlign.Center)
        .onClick(()=>{
          clearInterval(this.timer)
          router.replaceUrl({url:'pages/Index'})
        })
    }
    .height('100%')
    .width('100%')
  }
}