

  // Deprecating barcode scanning until further notice
  // Widget _barcodeButton(IconData icon, Function callback) {
  //   return InkWell(
  //     child: Padding(
  //       padding: const EdgeInsets.fromLTRB(10,5,50,10),
  //       child: Icon(
  //         icon, 
  //         color: Colors.white,
  //         size: 40,
  //       )
  //     ),
  //     onTap: () async {
  //       await scanBarcodeNormal();
  //       Navigator.push(context, MaterialPageRoute(
  //           builder: (context) => SaveToShelfFromBarcode(
  //             barcodeValue: _scanBarcode,
  //             foodIdValue: generateFoodId(),
  //           )
  //         ));
  //     },
  //   );
  // }