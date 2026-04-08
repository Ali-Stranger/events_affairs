import  'package:flutter/material.dart';
import 'eventplanner.dart';
import 'footer.dart';
import 'drawer.dart';

class CreateHomePage extends StatefulWidget {
  const CreateHomePage({super.key});

  @override
  State<CreateHomePage> createState() => _CreateHomePageState();
}


List<String> categories = ["Wedding", "Catering", "Photography", "Decoration"];
List<String> locations = ["Lahore", "Karachi", "Islamabad", "Multan"];

class _CreateHomePageState extends State<CreateHomePage> {
  bool isRegisterMode = false;
  bool rememberMe = false;
  String? selectedCategory;
String? selectedLocation;

String? formCategory;       // 👈 NEW
  String? formLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,


      
      // ✅ SIDEBAR MENU
     drawer: const CommonDrawer(),
      appBar: const CommonAppBar(),
      body: SingleChildScrollView(
  child: Column(
    children: [

      // ================= HEADER =================
      Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),

          Image.asset(
            'assets/images/logo.png',
            width: 90,
            height: 90,
          ),
        ],
      ),

      // ================= STACK SECTION =================
      Stack(
        clipBehavior: Clip.none,
        children: [

          // 🖼 BACKGROUND IMAGE
          Container(
            height: 390,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/download.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🌑 DARK OVERLAY
          Container(
            height: 350,
            width: double.infinity,
            color: Colors.black.withOpacity(0.2),
          ),

          // 📦 SEARCH BOX (HALF INSIDE + HALF OUTSIDE)
          Positioned(
            top: 220, // 👈 this creates half overlap effect
            left: 15,
            right: 15,
            child: 
             
               Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 27, 25, 25).withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                children: [

                  // Vendor Name
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type Vendor Name",
                      hintStyle: const TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xffB4245D),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xffB4245D),
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffB4245D), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      hint: const Text(
                        "Select Category",
                        style: TextStyle(color: Colors.white),
                      ),
                      isExpanded: true,
                      iconEnabledColor: Colors.white, 
                      dropdownColor: Colors.black,
                      underline: const SizedBox(),
                      items: categories.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Location
                  Container(
  padding: const EdgeInsets.symmetric(horizontal: 10),
  decoration: BoxDecoration(
    border: Border.all(color: const Color(0xffB4245D), width: 2),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Theme(
    data: Theme.of(context).copyWith(
      canvasColor: Colors.black, // dropdown background
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedLocation,
        hint: const Text(
          "Select Location",
          style: TextStyle(color: Colors.white,
          fontSize: 16,           // 👈 dropdown item size
              fontWeight: FontWeight.w500,),
        ),
        isExpanded: true,
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: Colors.white,
        items: locations.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: Colors.white,
              fontSize: 16,           // 👈 dropdown item size
              fontWeight: FontWeight.w500,),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedLocation = value;
          });
        },
      ),
    ),
  ),
),

                  const SizedBox(height: 15),

                  // BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffB4245D),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Find Vendor",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
      ),

      // 👇 EXTRA SPACE so scroll works properly
      const SizedBox(height: 160),
      Text('Customer Inquiries',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
      Text('Explore Wedding Categories',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
      Center(
  child: Text(
    'Explore & Search different Vendors of your choice i.e. Caterers, Florists, Event Planners, Farmhouses etc.',
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),
  ),
),

//-------Event Planners-----------
  Container(
  padding: EdgeInsets.all(12),
  margin: EdgeInsets.only(top: 5,left: 10,right: 10),
  decoration: BoxDecoration(
    color: Color(0xFFF4D5C2),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    children: [
      // Image
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          "assets/images/download.jpg",
          width: 60,
          height: 60,
          fit: BoxFit.cover,
           errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.image_not_supported);
  },
        ),
      ),
//D:\FCCU\MADP\Project\events_affairs\assets\images\event_planner.jpeg
      SizedBox(width: 10),

      // Text
      Expanded(
  child: InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Eventplanner(),
        ),
      );
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Planners',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'Find the best Event Planners',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ],
    ),
  ),
)
    ],
  ),
),

// ----------------Florist Decoration-----------
Container(
  padding: EdgeInsets.all(12),
  margin: EdgeInsets.only(top: 5,left: 10,right: 10),
  decoration: BoxDecoration(
    color: Color(0xFFCFCDB8),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    children: [
      // Image
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/download.jpg',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported),
        ),
      ),

      SizedBox(width: 10),

      // Text
      Expanded( // ⭐ IMPORTANT FIX
        child: InkWell( 
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> const Eventplanner())),
          child:Column( 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Florist/Decoration',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Search Best Florist',
              maxLines: 2, // ⭐ prevents overflow
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),)
      ),
    ],
  ),
),
//----------------Banquet Halls------------------
Container(
  padding: EdgeInsets.all(12),
  margin: EdgeInsets.only(top: 5,left: 10,right: 10),
  decoration: BoxDecoration(
    color: Color(0xFFDFB2AD),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    children: [
      // Image
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/download.jpg',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported),
        ),
      ),

      SizedBox(width: 10),

      // Text
      Expanded( // ⭐ IMPORTANT FIX
        child:InkWell(
           onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> const Eventplanner())),
         
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bnaquet Halls',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Find the Banquet Halls',
              maxLines: 2, // ⭐ prevents overflow
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),),
      ),
    ],
  ),
),
//------------Marque---------


Container(
  padding: EdgeInsets.all(12),
  margin: EdgeInsets.only(top: 5,left: 10,right: 10),
  decoration: BoxDecoration(
    color: Color(0xFFD8DFFC),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    children: [
      // Image
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/download.jpg',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported),
        ),
      ),

      SizedBox(width: 10),

      // Text
      Expanded( // ⭐ IMPORTANT FIX
        child:InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> const Eventplanner())),
         child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Marque',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Find the best Marque',
              maxLines: 2, // ⭐ prevents overflow
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),),
      ),
    ],
  ),
),

//--------FarmHouse------------
Container(
  padding: EdgeInsets.all(12),
  margin: EdgeInsets.only(top: 5,left: 10,right: 10),
  decoration: BoxDecoration(
    color: Color(0xFFE5D3BD),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    children: [
      // Image
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/download.jpg',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported),
        ),
      ),

      SizedBox(width: 10),

      // Text
      Expanded( // ⭐ IMPORTANT FIX
        child:InkWell(
           onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> const Eventplanner())),
          child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Farm House',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Search Farm Houses',
              maxLines: 2, // ⭐ prevents overflow
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),)
      ),
    ],
  ),
),

//-----------PhotoGraphers----------
Container(
  padding: EdgeInsets.all(12),
  margin: EdgeInsets.only(top: 5,left: 10,right: 10),
  decoration: BoxDecoration(
    color: Color(0xFFDCF7F7),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    children: [
      // Image
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/download.jpg',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported),
        ),
      ),

      SizedBox(width: 10),

      // Text
      Expanded( // ⭐ IMPORTANT FIX
        child:InkWell(
           onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> const Eventplanner())),
          child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Photographers',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Search Best Photographers',
              maxLines: 2, // ⭐ prevents overflow
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),),
      ),
    ],
  ),
),

Padding(
  padding: const EdgeInsets.only(top: 8),
  child: Column(
    children: [
      Text('Get Best Quote For Your Event',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
      Text('Fill the Form and Get Best Quotes Instantly from different Vendors.',textAlign:TextAlign.center ,
      style:TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
    ],
  ),
),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Column(
    children: [
  
      // ================= ROW 1 =================
      Row(
        children: [
  
          // 👤 Name Field
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
  
          SizedBox(width: 10),
  
          // 📂 Category Dropdown
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: formCategory,
                hint: Text("Category"),
                underline: SizedBox(),
                items: categories.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    formCategory = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
  
      SizedBox(height: 15),
  
      // ================= ROW 2 =================
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<String>(
          isExpanded: true,
          value: formLocation,
          hint: Text("Select City"),
          underline: SizedBox(),
          items: locations.map((value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              formLocation = value;
            });
          },
        ),
      ),
  
      SizedBox(height: 15),
  
      // ================= ROW 3 =================
      TextField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: "Contact Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
  
      SizedBox(height: 15),
  
      // ================= ROW 4 =================
      TextField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Event Date",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
  
          if (pickedDate != null) {
            setState(() {
              // store date if needed
            });
          }
        },
      ),
  
      SizedBox(height: 20),
  
      // ================= ROW 5 BUTTON =================
      SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xffB4245D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            // Submit action
          },
          child: Text(
            "Get a Quote",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    ],
  ),
),
SizedBox(height: 6,),

const AppFooter()
    ],
  ),
),
  


  
      );
  
    
  }
}