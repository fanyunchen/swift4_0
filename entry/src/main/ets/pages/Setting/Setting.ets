import { HMCard, HMCardItem, HMNavBar } from '../../components'
import router from '@ohos.router'
import { HMConfirm } from '../../components'
import promptAction from '@ohos.promptAction'
import { TOKEN_KEY } from '../../constants'
import { UserSettingClass } from '../../utils'

PersistentStorage.persistProp(TOKEN_KEY, '')

@Entry
@Component
struct Setting {
  // 用户退出提示弹框
  confirm: CustomDialogController = new CustomDialogController({
    builder: HMConfirm({
      message: '确认要退出登录吗？',
      buttonList: [
        {
          text: '取消'
        },
        {
          text: '确定',
          fontColor: $r('app.color.primary'),
          action: () => {
            this.logOut()
          }
        }
      ]
    }),
    autoCancel: false,
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  /**
   * 用户退出
   */
  async logOut() {
    // 清空token
    AppStorage.set(TOKEN_KEY, "") // 清空本地缓存
    try {
      await new UserSettingClass(getContext()).setUserToken("") // 清空首选项
      // 跳转页面
      router.replaceUrl({ url: "pages/Login/Login" })
      router.clear()
      promptAction.showToast({ message: '用户已登出' })
    } catch (err) {
      console.error('hmlog-->', "logOut Failed.Err:" + JSON.stringify(err))
    }
  }

  build() {
    Column({ space: 20 }) {
      HMNavBar({ title: "系统设置" })

      HMCard() {
        HMCardItem({ leftText: "换绑手机" })
        HMCardItem({ leftText: "修改密码" })
        HMCardItem({ leftText: "消息通知设置" })
        HMCardItem({ leftText: "清理缓存", showBorder: false })
      }

      Row() {
        Button("退出")
          .fontColor($r('app.color.text_primary'))
          .width('100%')
          .height(60)
          .type(ButtonType.Normal)
          .borderRadius(8)
          .backgroundColor($r('app.color.white'))
          .onClick(() => {
            this.confirm.open()
          })
      }.width('100%')
      .padding(14)

    }.width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}