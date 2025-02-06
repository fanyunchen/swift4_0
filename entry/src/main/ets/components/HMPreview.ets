@CustomDialog
@Component
export struct HMPreview {
  controller: CustomDialogController
  urls: string[] = [] // 图片列表
  selectIndex: number = -1 // 当前显示图片的下标

  build() {
    Column() {
      Row() {
        Swiper() {
          ForEach(this.urls, (item: string) => {
            Row() {
              Image(item)
                .width('100%')
                .objectFit(ImageFit.Contain)
            }.height('100%')
            .onClick(() => {
              this.controller.close()
            })
          })
        }.index(this.selectIndex)
        .indicator(false) // 取消导航条
        .loop(false)
      }.height('100%')
      .backgroundColor($r('app.color.black'))
    }.width('100%')
  }
}