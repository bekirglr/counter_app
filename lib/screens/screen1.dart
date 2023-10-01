import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";


class ScreenOne extends StatefulWidget {
  const ScreenOne({super.key});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

//Sayaç değerlerini saklamak için oluşturulmuş bir sınıf.
class CounterStorage {
  Future<int> getCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('counter') ?? 0;
  }

  Future<void> setCounter(int counter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', counter);
  }
}

//Eye Status saklamak için oluşturulmuş bir sınıf.
class EyeStorage {
  Future<bool> getEyeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('eyeStatus') ?? false;
  }

  Future<void> setEyeStatus(bool isOpen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('eyeStatus', isOpen);
  }
}

//Visible Status saklamak için oluşturulmuş bir sınıf.
class VisibleStorage {
  Future<bool> getVisibleStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('visibleStatus') ?? false;
  }

  Future<void> setVisibleStatus(bool isVisible) async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); 
    await prefs.setBool('visibleStatus', isVisible);
  }
}

class _ScreenOneState extends State<ScreenOne> {


  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _counterEditingController = TextEditingController(); //sayaç nesnesi 
  final TextEditingController _titleEditingController = TextEditingController();
  final CounterStorage _counterStorage = CounterStorage(); // Yeni sayaç depolama nesnesi
  final EyeStorage _eyeStorage = EyeStorage(); // Yeni eye status depolama nesnesi
  final VisibleStorage _visibleStorage = VisibleStorage(); //Visible status depolama nesnesi
  final FocusNode _textFocusNode = FocusNode(); //Form'un seçilebilir yapması için bir nesne
  //final FocusNode _counterFocusNode = FocusNode();//Counter'ın seçilebilir yapması için bir nesne
  final FocusNode _titleFocusNode = FocusNode(); //Title'ın seçilebilir yapması için bir nesne
  bool isVisible = false; // Ekranın görünürlüğünü kontrol etmek için bir değişken
  bool isEyeOpen = false;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
    _loadEyeStatus();
    _loadVisibleStatus();
    _loadSavedText(); // Kaydedilen metni yüklemek için bu fonksiyonu çağırdım.
    _loadSavedTitle();
    _loadSavedCounter();
  }


  /*______________________________________ */
void _saveText() async {
  String textToSave = _textEditingController.text;
  // Burada metni SharedPreferences ile kaydedebilirsiniz
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('savedText', textToSave);
}
void _loadSavedText() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedText = prefs.getString('savedText') ?? '';
  _textEditingController.text = savedText;
}

  /*______________________________________ */
void _saveTitle() async {
  String titleToSave = _titleEditingController.text;
  // Burada metni SharedPreferences ile kaydedebilirsiniz
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('savedTitle', titleToSave);
}

void _loadSavedTitle() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedTitle = prefs.getString('savedTitle') ?? '';
  _titleEditingController.text = savedTitle;
}

  /*______________________________________ */
void _saveCounter() async {
  String counterToSave = _counterEditingController.text;
  // Burada metni SharedPreferences ile kaydedebilirsiniz
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('savedCounter', counterToSave);
}

void _loadSavedCounter() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedCounter = prefs.getString('savedCounter') ?? '';
  _counterEditingController.text = savedCounter;
}

  /*______________________________________ */
  void _loadCounter() async {
    int storedCounter = await _counterStorage.getCounter();
    setState(() {
      _counter = storedCounter;
    });
  }
  void _incrementCounter() {
    setState(() {
      _counter++;
      _counterStorage.setCounter(_counter);
    });
  }
  void _decrementCounter() {
    setState(() {
      _counter--;
      _counterStorage.setCounter(_counter);
    });
  }

  /*______________________________________ */
  void _loadEyeStatus() async {
    bool storedEyeStatus = await _eyeStorage.getEyeStatus();
    setState(() {
    isEyeOpen = storedEyeStatus;
  });
  }
  void _toggleEye() {
    setState(() {
      isEyeOpen = !isEyeOpen;
      _eyeStorage.setEyeStatus(isEyeOpen);
    });
  }

  /*___________________________________ */
  void _loadVisibleStatus() async {
    bool storageVisibleStatus = await _visibleStorage.getVisibleStatus();
    setState(() {
      isVisible = storageVisibleStatus;
    });
  }
  void _toggleVisible(){ 
    setState(() {
      isVisible = !isVisible;
      _visibleStorage.setVisibleStatus(isVisible);
    });
  }

/*___________________________________ */

  @override
  Widget build(BuildContext context) {

    double bodyTextLeftPadding = MediaQuery.of(context).size.height * 0.03;
    double bodyTextRightPadding = MediaQuery.of(context).size.height * 0.03;
    double textFormRightPadding = MediaQuery.of(context).size.height * 0.02;
    double textFormTopPadding = MediaQuery.of(context).size.height * 0.03;


    // Ekran yüksekliğinin %1'i kdar boşluk
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: <Widget>[
          IconButton(onPressed: () {
            _saveText();
            _saveTitle();
            _saveCounter();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Saved..."),
                duration: const Duration(milliseconds: 1300),
                width: 200,
                behavior:SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide.none
                ),
                backgroundColor: const Color.fromARGB(255, 61, 130, 63),
            )
            );
          },
          icon: const Icon(FeatherIcons.save),
          iconSize: 30,
          padding: const EdgeInsets.only(right: 20),
          )
        ],
      ),
      body: Column(
        children: [
          Visibility(
            visible: isVisible,
            child: Container(
              margin: const EdgeInsets.only(top: 10.0),
              padding: const EdgeInsets.only(left: 20, right: 20),
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(20),
              ),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(_titleFocusNode);
                },
                child: TextFormField(
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  controller: _titleEditingController,
                  focusNode: _titleFocusNode,
                  cursorColor: Colors.black,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Title",
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                    )
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isVisible,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    '$_counter',
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    
                  ),
              ],
            ),
          ),
          Visibility(
            visible: isVisible,
            child:
              SizedBox(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Gölge rengi ve opaklık
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(textFormRightPadding, 0, 0,textFormRightPadding),
                  margin: EdgeInsets.fromLTRB(bodyTextLeftPadding, textFormTopPadding, bodyTextRightPadding, textFormTopPadding),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(_textFocusNode); //Container nesnesine tıkladıktan sonra formu focus yap
                    },
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: TextFormField(
                        controller: _textEditingController,
                        // keyboardType: TextInputType.number, // Klavye türünü sadece sayı girişi olarak ayarladım.
                        focusNode: _textFocusNode,
                        cursorColor: Colors.black,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter text...',
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic
                          )
                        ),
                      )
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: const Drawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.do_disturb_on, color: Color.fromARGB(255, 27, 94, 32)),
            label: 'Azalt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, color: Color.fromARGB(255, 27, 94, 32)),
            label: 'Arttır',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            _decrementCounter();
          } else if (index == 1) {
            _incrementCounter();
          }
        },
        type: BottomNavigationBarType.fixed, // Tüm öğeleri eşit boyutta göstermek için
        iconSize: 35.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() {
          _toggleEye();
          _toggleVisible();
        },
        child: Icon(isEyeOpen ? FeatherIcons.eye : FeatherIcons.eyeOff),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


//KULLANICI METİN GÜNCELLEME KONTROL ET