import { Controller } from "stimulus"
import Highcharts from "highcharts"
import maps from 'highcharts/modules/map'
maps(Highcharts)

import europe from "@highcharts/map-collection/custom/europe.geo.json"
import world from "@highcharts/map-collection/custom/world.geo.json"

export default class extends Controller {
  static targets = []

  initialize(){
  }

  connect() {
    this.generateChart(this.element)
  }

  generateChart(element){
    console.log(JSON.parse(element.dataset.places))
    Highcharts.mapChart(element, {
      chart: {
        map: "custom/europe"
      },
      title: {
        text: 'Countries serviced by '
      },
      legend: {
        enabled: false
      },
      series: [{
        name: 'Country',
        data: JSON.parse(element.dataset.places),
        dataLabels: {
          enabled: true,
          color: '#FFFFFF'
        },
        tooltip: {
          headerFormat: '',
          pointFormat: '{point.name}'
        }
      }]
    });
  }
}
