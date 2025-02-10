import { HMCard, HMCardItem, HMNavBar } from '../../components';
import { APP_TOP_HEIGHT } from '../../constants';
import { geoLocationManager } from '@kit.LocationKit';

@Entry
@Component
struct SelectLocation {
  aboutToAppear(): void {
    this.getLocation()
  }

  /**
   * 获取当前位置
   */
  async getLocation() {
    try {
      let location = await geoLocationManager.getCurrentLocation()
      AlertDialog.show({ message: JSON.stringify(location) })
    } catch (err) {
      AlertDialog.show({ message: JSON.stringify(err) })
    }
  }

  build() {
    Column() {
      Row()
        .width('100%')
        .height(AppStorage.get(APP_TOP_HEIGHT))
        .backgroundColor($r('app.color.white'))
      HMNavBar({ title: "当前位置" })
      Text('地图')
      Column() {
        HMCard() {
          HMCardItem({ leftText: "上海滩", rightText: '100m以内' })
          HMCardItem({ leftText: "金色大厅", rightText: '100m以内' })
          HMCardItem({ leftText: "维也纳", rightText: '100m以内' })
          HMCardItem({ leftText: "中山公园", rightText: '100m以内' })
        }
      }
      .position({ y: '100%' })
      .translate({ y: -300 })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}