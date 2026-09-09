class SliderModel {
  int? sliderId;
  String? sliderTitle;
  String? sliderBody;
  String? sliderImage;

  SliderModel({
    this.sliderId,
    this.sliderTitle,
    this.sliderBody,
    this.sliderImage,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      sliderId: int.tryParse(json['slider_id']?.toString() ?? ''),
      sliderTitle: json['slider_title']?.toString() ?? json['slider_name']?.toString() ?? '',
      sliderBody: json['slider_body']?.toString() ?? json['slider_desc']?.toString() ?? '',
      sliderImage: json['slider_image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slider_id': sliderId,
      'slider_title': sliderTitle,
      'slider_body': sliderBody,
      'slider_image': sliderImage,
    };
  }
}
