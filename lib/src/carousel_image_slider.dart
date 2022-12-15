import 'package:carousel_image_slider/src/image_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class Carousel extends StatefulWidget {
  const Carousel({
    Key? key,
    required this.imagePaths,
    this.imagePadding,
    this.imageBorderRadius,
    this.imageContainerMargin,
    this.showController = true,
    this.enlargeCenterPage,
    this.pageSnapping,
    this.enableInfiniteScroll,
    this.viewportFraction,
    this.autoplay,
    this.autoPlayInterval,
    this.reverse,
    this.initialPage,
    this.aspectRatio,
    this.carouselHeight,
    this.carouselInitialPage,
    this.networkImage = false,
    this.boxFit = BoxFit.cover,
    this.buttonBackgroundColor,
    this.imageIndicatorColor,
    this.buttonSize,
    this.previuosPageDuration,
    this.nextPageDuration,
    this.placeholderImage,
  }) : super(key: key);

  final EdgeInsetsGeometry? imagePadding;
  final BorderRadius? imageBorderRadius;
  final EdgeInsetsGeometry? imageContainerMargin;
  final List<String> imagePaths;
  final bool? enlargeCenterPage;
  final bool showController;
  final bool? pageSnapping;
  final bool? enableInfiniteScroll;
  final double? aspectRatio;
  final double? viewportFraction;
  final bool? autoplay;
  final bool? reverse;
  final int? initialPage;
  final Duration? autoPlayInterval;
  final Duration? previuosPageDuration;
  final Duration? nextPageDuration;
  final bool networkImage;
  final BoxFit boxFit;
  final double? carouselHeight;
  final int? carouselInitialPage;
  final Color? buttonBackgroundColor;
  final Color? imageIndicatorColor;
  final double? buttonSize;
  final String? placeholderImage;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final controller = CarouselController();
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _carouselBody(),
      ],
    );
  }

  Widget _carouselBody() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(),
        SizedBox(
          child: Column(
            children: [
              CarouselSlider.builder(
                  carouselController: controller,
                  itemCount: widget.imagePaths.length,
                  itemBuilder: (context, index, realIndex) {
                    final imagePath = widget.imagePaths[index];
                    return buildImage(imagePath, index);
                  },
                  options: CarouselOptions(
                    height: widget.carouselHeight ??
                        MediaQuery.of(context).size.height * 0.25,
                    onPageChanged: ((index, reason) =>
                        setState(() => activeIndex = index)),
                    enlargeCenterPage: widget.enlargeCenterPage ?? false,
                    initialPage: widget.carouselInitialPage ?? 0,
                    aspectRatio: widget.aspectRatio ?? 4 / 3,
                    pageSnapping: widget.pageSnapping ?? false,
                    enableInfiniteScroll: widget.enableInfiniteScroll ?? false,
                    viewportFraction: widget.viewportFraction ?? 0.9,
                    autoPlay: widget.autoplay ?? true,
                    reverse: widget.reverse ?? false,
                    autoPlayInterval:
                        widget.autoPlayInterval ?? const Duration(seconds: 3),
                  )),
              const SizedBox(
                height: 22,
              ),
              buildIndicator()
            ],
          ),
        ),
        widget.showController ? buildButtons() : Container()
      ],
    );
  }

  Widget buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators(
        widget.imagePaths.length,
        activeIndex,
      ),
    );
  }

  List<Widget> indicators(int imagePathsLength, int activeIndex) {
    return List<Widget>.generate(imagePathsLength, (index) {
      return Container(
        margin: const EdgeInsets.all(3),
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          color: activeIndex == index
              ? widget.imageIndicatorColor ?? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
        ),
      );
    });
  }

  Widget buildButtons() => Row(
        children: [
          ElevatedButton(
              onPressed: previous,
              style: ElevatedButton.styleFrom(
                  primary: widget.buttonBackgroundColor ??
                      const Color.fromARGB(153, 221, 217, 217),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 6),
                  shape: const CircleBorder()),
              child: Icon(
                Icons.arrow_back,
                size: widget.buttonSize ?? 20,
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
          ),
          ElevatedButton(
              onPressed: next,
              style: ElevatedButton.styleFrom(
                  primary: widget.buttonBackgroundColor ??
                      const Color.fromARGB(153, 221, 217, 217),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 42.8, vertical: 6),
                  shape: const CircleBorder()),
              child: const Icon(
                Icons.arrow_forward,
                size: 20,
              )),
        ],
      );

  void next() => controller.nextPage(
      duration: widget.nextPageDuration ?? const Duration(milliseconds: 500));

  void previous() => controller.previousPage(
      duration:
          widget.previuosPageDuration ?? const Duration(milliseconds: 500));
  Widget buildImage(String imagePath, int index) => Container(
        margin: widget.imageContainerMargin ??
            const EdgeInsets.symmetric(horizontal: 12),
        child: ClipRRect(
          borderRadius: widget.imageBorderRadius ?? BorderRadius.circular(14),
          child: Image.network(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              final height = widget.carouselHeight ?? MediaQuery.of(context).size.height * 0.25;
              final width = height * (widget.aspectRatio ?? 4/3);
              return ImagePlaceHolder(widget.placeholderImage ?? "", height, width) ;
            },
          ),
        ),
      );
}

