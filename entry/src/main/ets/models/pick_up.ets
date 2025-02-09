import { ImageList } from "."

export interface PickUpParams {
  id: string
  cargoPickUpPictureList: ImageList[]
  cargoPictureList: ImageList[]
}

export class PickUpParamsModel implements PickUpParams {
  id: string = ''
  cargoPickUpPictureList: ImageList[] = []
  cargoPictureList: ImageList[] = []

  constructor(model: PickUpParams) {
    this.id = model.id
    this.cargoPickUpPictureList = model.cargoPickUpPictureList
    this.cargoPictureList = model.cargoPictureList
  }
}