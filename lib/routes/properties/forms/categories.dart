import 'package:flutter/material.dart';
import '../../../model/category_model.dart';

class CategoryInteractor {
  static Widget select(BuildContext context) {
    return FutureBuilder(
      future: Category.fetchAll(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<Widget> children = [Text("Hey")];

        /// If data was returned from the database
        if (snapshot.hasData) {
          children.add(
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  //todo: Populate the children list
                  return Text(snapshot.data[index]);
                }),
          );
        } else {
          children.add(
            SizedBox(
              width: MediaQuery.of(context).size.width * .15,
              height: MediaQuery.of(context).size.height * .15,
              child: const CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
          );
          children.add(const Text("Waiting for Data"));
        }

        return SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }
}
