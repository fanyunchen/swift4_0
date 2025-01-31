@Component
struct HMCardItem {
  leftText:string = ''
  rightText:string = ''
  showRightIcon:boolean = true
  showBorder:boolean = true
  click:()=>void = ()=>{}
  build() {
    Row(){
      Text(this.leftText)
        .fontWeight(400)
        .fontColor($r("app.color.text_primary"))

      Row(){
        if (this.rightText){
          Text(this.rightText)
            .fontSize(14 )
            .fontWeight(400)
            .fontColor($r("app.color.text_primary"))
        }
        if (this.showRightIcon){
        Image($r("app.media.ic_btn_more"))
          .width(24)
          .aspectRatio(1)
          }
      }.onClick(()=>{
        this.click()
      })
      
    }.width('100%')
    .border({width:{
      bottom:this.showBorder ? 1 : 0
    },
      color:$r('app.color.background_divider')
    })
    .height(60)
    .justifyContent(FlexAlign.SpaceBetween)

  }
}

export { HMCardItem }