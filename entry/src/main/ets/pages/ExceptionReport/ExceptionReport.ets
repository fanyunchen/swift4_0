import { HMCard, HMCardItem, HMLoading, HMNavBar, HMSelectCard, HMUpload, UploadFile } from '../../components';
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../constants';
import { CommonRouterParams, ExceptionParams, ExceptionParamsModel, exceptionType } from '../../models';
import { promptAction, router } from '@kit.ArkUI';
import dayjs from '@hview/dayjs';
import { exceptionReport } from '../../api';

@Entry
@Component
struct ExceptionReport {
  maxSizeNumber: number = 200;
  exceptionErrorList: string[] = [
    "发动机启动困难",
    "不着车、漏油",
    "照明失灵",
    "有异常响动",
    "排烟异常、温度异常",
    "其他问题"
  ]
  @State exceptionForm: ExceptionParamsModel = new ExceptionParamsModel({} as ExceptionParams)
  @State selectIndex: number = -1
  typeDialog: CustomDialogController = new CustomDialogController({
    builder: HMSelectCard({
      cardContent: () => {
        this.getCardContent()
      },
      confirm: () => {
        if (this.selectIndex !== -1) {
          this.exceptionForm.exceptionType = this.exceptionErrorList[this.selectIndex]
        }
      }
    }),
    autoCancel: false,
    customStyle: true,
    alignment: DialogAlignment.Bottom
  })
  layer: CustomDialogController = new CustomDialogController({
    builder: HMLoading({ loadingText: "异常上报中，请耐心等待！" }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  @Builder
  getCardContent() {
    ForEach(this.exceptionErrorList, (name: string, index) => {
      this.getSingleItem(new ExceptionItemClass(name, index))
    })
  }

  // forEach 只有引用类型才会在改变时随之改变
  // 提供每个类型的样式
  @Builder
  getSingleItem(item: ExceptionItemClass) {
    Row() {
      Text(item.name)
        .fontSize(14)
        .fontWeight(400)
        .fontColor($r('app.color.text_primary'))
      Image(this.selectIndex === item.index ? $r('app.media.ic_check_true') : $r('app.media.ic_check_false'))
        .width(32)
        .aspectRatio(1)
    }
    .onClick(() => {
      this.selectIndex = item.index
    })
    .width('100%')
    .height(60)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: 15, right: 15 })
    .border({
      width: { bottom: 1 },
      color: $r('app.color.background_divider')
    })
  }

  // aboutToAppear(): void {
  //   const params = router.getParams() as CommonRouterParams
  //   if (params && params.id) {
  //     this.exceptionForm.transportTaskId = params.id
  //   }
  // }

  onPageShow(): void {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id) {
      this.exceptionForm.transportTaskId = params.id
    }
    if (params && params.address) {
      console.log('hmlog-->', "exceptionPlace:" + params.address)
      this.exceptionForm.exceptionPlace = params.address
    }
  }

  getBtnEnable() {
    return !!(this.exceptionForm.exceptionTime && this.exceptionForm.transportTaskId &&
    this.exceptionForm.exceptionPlace && this.exceptionForm.exceptionType)
  }

  /**
   * 实现异常上报
   */
  async btnReport() {
    try {
      this.layer.open()
      if (this.exceptionForm.exceptionType === '其他问题' && this.exceptionForm.exceptionDescribe === undefined) {
        promptAction.showToast({ message: '选择其他问题时，异常描述为必填项' })
        return
      }
      if (this.exceptionForm.exceptionType === '其他问题' && this.exceptionForm.exceptionDescribe === '') {
        promptAction.showToast({ message: '选择其他问题时，异常描述为必填项' })
        return
      }
      // 图片上传
      if (this.exceptionForm.exceptionImagesList?.length) {
        this.exceptionForm.exceptionImagesList = await UploadFile(this.exceptionForm.exceptionImagesList)
      }
      // 调用后端接口，上报异常
      await exceptionReport(this.exceptionForm)
      promptAction.showToast({ message: '异常上报成功', duration: 2000 })
      // 返回交货页面
      router.back({
        url: "pages/TaskDetail/TaskDetail",
        params: { addException: true }
      })
    } catch (err) {
      AlertDialog.show({ message: '上报异常错误！' + JSON.stringify(err.message) })
    } finally {
      this.layer.close()
    }
  }

  build() {
    Column() {
      Row().width('100%')
        .height(AppStorage.get(APP_TOP_HEIGHT))
        .backgroundColor($r('app.color.white'))

      HMNavBar({ title: '上报异常' })

      Scroll() {
        Column() {
          HMCard() {
            HMCardItem({
              leftText: '异常时间',
              rightText: this.exceptionForm.exceptionTime ? this.exceptionForm.exceptionTime + ":00" : "请选择",
              click: () => {
                DatePickerDialog.show({
                  showTime: true,
                  useMilitaryTime: true,
                  alignment: DialogAlignment.Bottom,
                  onDateAccept: (value) => {
                    this.exceptionForm.exceptionTime = dayjs(value).format('YYYY-MM-DD HH:mm')
                  }
                })
              }
            })
            HMCardItem({
              leftText: '上报位置', rightText: this.exceptionForm.exceptionPlace || "请选择", click: () => {
                router.pushUrl({
                  url: 'pages/SelectLocation/SelectLocation'
                })
              }
            })
            HMCardItem({
              leftText: '异常类型', rightText: this.exceptionForm.exceptionType || '请选择', click: () => {
                this.typeDialog.open()
              }
            })
            HMCardItem({
              leftText: '异常描述',
              rightText: '',
              showRightIcon: false,
              showBorder: false
            })

            TextArea({ placeholder: '请输入异常描述(选择其他时为必填项)', text: this.exceptionForm.exceptionDescribe })
              .backgroundColor($r('app.color.background_page'))
              .height(130)
              .fontSize(14)
              .placeholderColor($r('app.color.text_secondary'))
              .maxLength(this.maxSizeNumber)
              .borderRadius(8)
              .onChange((value) => {
                this.exceptionForm.exceptionDescribe = value
              })
            Text(`${this.exceptionForm.exceptionDescribe?.length || "0"}/${this.maxSizeNumber}`)
              .textAlign(TextAlign.End)
              .width('100%')
              .margin({ top: -30 })
              .padding({ right: 15 })
            Row()
              .height(30)
          }

          HMCard() {
            HMUpload({
              title: '上传图片(最多六张)',
              maxNumber: 6,
              imgList: this.exceptionForm.exceptionImagesList || [],
              onListChange: (imgList) => {
                this.exceptionForm.exceptionImagesList = imgList
              }
            })
            Row()
              .height(30)
          }
        }
        .padding({ bottom: 200 })
      }
      .scrollBar(BarState.Off)

      Row() {
        Button('提交')
          .height(50)
          .width(200)
          .backgroundColor($r('app.color.primary'))
          .enabled(this.getBtnEnable())
          .onClick(() => {
            this.btnReport()
          })
      }
      .padding({ left: 15, right: 15 })
      .width('100%')
      .height(70 + Number(AppStorage.get<number>(APP_BOTTOM_HEIGHT)))
      .position({ y: '100%' })
      .translate({ y: -(70 + Number(AppStorage.get<number>(APP_BOTTOM_HEIGHT))) })
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('app.color.white'))
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}

class ExceptionItemClass {
  name: string = ''
  index: number = -1

  constructor(name: string, index: number) {
    this.name = name
    this.index = index
  }
}