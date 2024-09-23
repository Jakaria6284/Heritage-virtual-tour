class Item {
   final String image;
   final String name;
   final String anotherImage;
   final String audio;

   Item({
      required this.image,
      required this.name,
      required this.anotherImage,
      required this.audio,
   });

   // Factory method to create an Item object from Firestore DocumentSnapshot
   factory Item.fromFirestore(Map<String, dynamic> data) {
      return Item(
         image: data['image'] ?? '',
         name: data['name'] ?? '',
         anotherImage: data['anotherImage'] ??'',
         audio: data['audio']??'',
      );
   }
}
