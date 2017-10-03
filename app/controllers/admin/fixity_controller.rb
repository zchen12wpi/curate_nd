class Admin::FixityController < ApplicationController
  with_themed_layout('1_column')

  def index
    pp params
    @fixity_results = JSON.parse('[
      {
          "Id": "20481",
          "Item": "id01931x",
          "Scheduled_time": "2017-09-01T00:23:32Z",
          "Status": "ok",
          "Notes": ""
      },
      {
          "Id": "20482",
          "Item": "id05534x",
          "Scheduled_time": "2017-09-01T00:23:32Z",
          "Status": "error",
          "Notes": ""
      },
      {
          "Id": "20483",
          "Item": "id08847x",
          "Scheduled_time": "2017-09-01T03:23:32Z",
          "Status": "ok",
          "Notes": ""
      },
      {
          "Id": "20484",
          "Item": "id04756x",
          "Scheduled_time": "2017-09-01T05:24:19Z",
          "Status": "scheduled",
          "Notes": ""
      },
      {
          "Id": "20485",
          "Item": "id06635x",
          "Scheduled_time": "2017-09-01T05:24:44Z",
          "Status": "scheduled",
          "Notes": ""
      },
      {
          "Id": "20486",
          "Item": "id09884x",
          "Scheduled_time": "2017-09-01T05:24:44Z",
          "Status": "mismatched",
          "Notes": ""
      },
      {
          "Id": "20487",
          "Item": "id06916x",
          "Scheduled_time": "2017-09-01T05:24:44Z",
          "Status": "ok",
          "Notes": ""
      }
    ]')
  end
end
