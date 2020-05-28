import 'package:alphabeticlist/view/http_animal_detail/http_animal_detail_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import './http_animal_view_model.dart';
import '../../core/components/alphabetic_list_view.dart';
import '../../core/constants/lottie_path.dart';
import 'model/animal.dart';

class HttpAnimalView extends HttpAnimalViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButtonRefresh,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [buildSliverLottie];
        },
        body: buildListViewBody,
      ),
    );
  }

  FloatingActionButton get buildFloatingActionButtonRefresh {
    return FloatingActionButton(
      child: buildIsLoadingWidget,
      onPressed: () async {
        await getHttpAnimalList();
      },
    );
  }

  Widget get buildIsLoadingWidget => isLoading
      ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        )
      : Icon(Icons.refresh);

  SliverToBoxAdapter get buildSliverLottie {
    return SliverToBoxAdapter(
      child: AspectRatio(
          aspectRatio: 2 / 1, child: Lottie.asset(LottiePath.PARTY_CAT)),
    );
  }

  Widget get buildListViewBody {
    return Visibility(
      visible: httpAnimalList.isNotEmpty,
      child: AlphabeticListView(
        headers: httpAnimalList.map((e) => e.description).toList(),
        itemCount: httpAnimalList.length,
        list: httpAnimalList,
        listKey: "description",
        item: (data, index) => Container(
          child: buildCardHttpAnimal(HTTPAnimalModel.fromJson(data)),
        ),
        // listKey: "description",
      ),
    );
  }

  Widget buildCardHttpAnimal(HTTPAnimalModel model) => AspectRatio(
        aspectRatio: 10 / 6,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HttpDetailView(
                tag: model.statusCode.toString(),
                imageUrl: model.imageUrl,
              ),
            ));
          },
          child: Card(
            child: Stack(
              children: [
                buildPositionedImage(model.imageUrl),
                buildPositionedImageBottom(model),
              ],
            ),
          ),
        ),
      );

  Positioned buildPositionedImage(String image) {
    return Positioned(
      left: 0,
      right: 0,
      child: Image.network(
        image,
        fit: BoxFit.fill,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          return Transform.scale(
            scale: 2,
            child: child,
          );
        },
      ),
    );
  }

  Positioned buildPositionedImageBottom(HTTPAnimalModel model) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.red,
        child: ListTile(
          leading: AutoSizeText(
            model.statusCode.toString(),
            style: Theme.of(context).primaryTextTheme.subtitle1,
          ),
          title: AutoSizeText(model.description,
              style: Theme.of(context).primaryTextTheme.headline5),
        ),
      ),
    );
  }
}
