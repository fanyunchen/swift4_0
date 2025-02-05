import { AdvertClass } from '../../models'
import router from '@ohos.router'
import { APP_TOP_HEIGHT, TOKEN_KEY } from '../../constants'
import { UserSettingClass } from '../../utils'

// 这里练习从PersistentStorage中读取Token
// 注意：PersistentStorage 只能在页面中使用
PersistentStorage.persistProp(TOKEN_KEY, '')

@Entry
@Component
struct Start {
  userSetting: UserSettingClass = new UserSettingClass(getContext(this))
  @State adObj: AdvertClass | null = null
  timer: number = 0 // 记录计时器

  async aboutToAppear(): Promise<void> {
    // 从首选项中获取广告数据
    this.adObj = await this.userSetting.getUserAd()
    // 实现广告倒计时
    this.timer = setInterval(() => {
      if (this.adObj!.adTime === 0) {
        // 判断是否有登录，没有跳转登录页面
        this.toNext()
        clearInterval(this.timer)
        return
      }
      this.adObj!.adTime--
    }, 1000)
  }

  toNext() {
    // 从PersistentStorage中读取token
    const token = AppStorage.get<string>(TOKEN_KEY)

    if (token === '') {
      router.replaceUrl({ url: 'pages/Login/Login' })
    } else {
      router.replaceUrl({ url: 'pages/Index/Index' })
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image(this.adObj?.adImg).objectFit(ImageFit.Cover)
      Text(`${this.adObj?.adTime} S后跳转`)
        .backgroundColor($r('app.color.background_page'))
        .padding({ left: 10, right: 10 })
        .height(30)
        .fontSize(14)
        .borderRadius(15)
        .margin({ top: Number(AppStorage.get<number>(APP_TOP_HEIGHT)) + 20, right: 20 })
        .textAlign(TextAlign.Center)
        .onClick(() => {
          clearInterval(this.timer)
          this.toNext()
        })
    }
    .height('100%')
    .width('100%')
  }
}