import { PickUpParamsModel, TaskDetailInfoModel, TaskListData, TaskListParams } from "../models";
import { Request } from "../utils";

/**
 * 获取任务列表接口
 */
export const getTaskList = (params: TaskListParams) => {
  return Request.get<TaskListData>("/tasks/list", params)
}

/**
 * 获取任务详情
 */
export const getTaskDetail = (id: string) => {
  return Request.get<TaskDetailInfoModel>(`/tasks/details/${id}`)
}

export const pickUp = (params: PickUpParamsModel) => {
  return Request.post<null>("/tasks/takeDelivery", params)
}