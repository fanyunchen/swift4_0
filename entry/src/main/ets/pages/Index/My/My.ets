import { HMCard, HMCardItem } from "../../../components"
import promptAction from "@ohos.promptAction"
import { getUserInfo, getUserTaskInfo } from "../../../api"
import { UserInfo, UserInfoModel, UserTaskInfo, UserTaskInfoModel, UserTaskInfoParamsModel } from "../../../models"
import router from "@ohos.router"

@Preview
@Component
export struct My {
  // 本月任务接口请求的查询参数
  queryTaskParams: UserTaskInfoParamsModel = new UserTaskInfoParamsModel({
    year: new Date().getFullYear().toString(),
    month: (new Date().getMonth() + 1).toString()
  })
  // 接收查询的司机信息
  @State userInfo: UserInfoModel = new UserInfoModel({} as UserInfo)
  // 接收查询的本月任务数据
  @State UserTaskInfo: UserTaskInfoModel = new UserTaskInfoModel({} as UserTaskInfo)

  aboutToAppear(): void {
    this.getUserInfo()
    this.getUserTaskInfo()
  }

  // 获取用户数据
  async getUserInfo() {
    try {
      const res = await getUserInfo()
      // if (res !== '' && res !== null) {
      //   this.userInfo = res
      // }
      if (res !== '') {
        this.userInfo = JSON.parse(JSON.stringify(res.data))
        console.log('hmlog-->', "UserInfo" + JSON.stringify(this.userInfo))
      }
    } catch (err) {
      console.error('hmlog-->', "getUserInfo Failed.Err:" + JSON.stringify(err))
    }
  }

  // 获取本月任务数据
  async getUserTaskInfo() {
    try {
      const res = await getUserTaskInfo(this.queryTaskParams)
      // if (res !== '' && res !== null) {
      //   this.UserTaskInfo = res
      //   // console.log('hmlog-->', 'UserTaskInfo:' + JSON.stringify(this.UserTaskInfo))
      // }
      if (res !== '') {
        this.UserTaskInfo = JSON.parse(JSON.stringify(res.data))
        console.log('hmlog-->', 'UserTaskInfo:' + JSON.stringify(this.UserTaskInfo))
      }
    } catch (err) {
      console.error('hmlog-->', "getUserTaskInfo Failed.Err:" + JSON.stringify(err))
    }
  }

  build() {
    Column() {
      // 1.基本信息
      Column() {
        // 头像
        Image(this.userInfo.avatar || $r('app.media.ic_avatar_driver'))
          .width(68)
          .aspectRatio(1)
          .borderRadius(34)
          .backgroundColor(Color.White)
        Text(this.userInfo.name || '司机名称')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .lineHeight(25)
          .fontColor($r('app.color.white'))
          .margin({ top: 9, bottom: 9 })
        Text(`司机编号：${this.userInfo.number}`)
          .fontSize(14)
          .fontWeight(400)
          .lineHeight(20)
          .fontColor($r('app.color.white'))
        Text(`手机号：${this.userInfo.phone}`)
          .fontSize(14)
          .fontWeight(400)
          .lineHeight(20)
          .fontColor($r('app.color.white'))
          .margin({ top: 9 })
      }
      .backgroundImage($r('app.media.bg_page_my'))
      .backgroundImageSize(ImageSize.Cover)
      .width('100%')
      .height(292)
      .margin({ top: -2 })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      // 2.本月任务
      Column() {
        Text('-本月任务-')
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
          .lineHeight(20)
        Row() {
          Column({ space: 17 }) {
            Text(this.UserTaskInfo.taskAmounts?.toString() || '0')
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
            Text('任务总量')
              .fontSize(12)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(17)
          }

          Column({ space: 17 }) {
            Text(this.UserTaskInfo.taskAmounts?.toString() || '0')
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
            Text('完成任务量')
              .fontSize(12)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(17)
          }

          Column({ space: 17 }) {
            Text(this.UserTaskInfo.transportMileage?.toString() || '0')
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
            Text('运输里程(km)')
              .fontSize(12)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(17)
          }
        }.width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 9 })
      }
      .backgroundColor($r('app.color.white'))
      .height(134)
      .borderRadius(8)
      .margin({
        top: -55,
        left: 13,
        right: 13,
        bottom: 13
      })
      .padding(13)

      // 3.综合信息
      HMCard() {
        HMCardItem({ leftText: "车辆信息", rightText: "沪A xxxxx" })
        HMCardItem({ leftText: '任务数据', rightText: "1000", showRightIcon: false })
        HMCardItem({
          leftText: '系统设置', click: () => {
            router.pushUrl({ url: "pages/Setting/Setting" })
          }, showBorder: false
        })
      }
    }.width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}