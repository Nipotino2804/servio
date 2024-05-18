// Default App Informations
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const String appTitle = 'Servio';
Color primaryColor = const Color.fromRGBO(11, 65, 140, 1);
Color cardColor = Colors.grey;

/// MySql Database
// Orders
List<String> titles = [];
List<String> descriptions = [];
List<String> clients = [];
List<String> workers = [];
List<bool> completeds = [];
List<String> createTimes = [];
List<String> orderIds = [];

List<String> finishedTitles = [];
List<String> finishedDescriptions = [];
List<String> finishedClients = [];
List<String> finishedWorkers = [];
List<bool> finishedCompleteds = [];
List<String> finishedCreateTimes = [];
List<String> finishedOrderIds = [];

// Protocol
List<String> protocolOrderId = [];
List<String> protocolDescription = [];
List<String> protocolSolved = [];
List<String> protocolWorker = [];
String newProtocolDescription = '';
bool protocolSolvedController = true;
bool protocolSaved = false;
bool protocolReadOnly = false;
TextEditingController protocolDescriptionController = TextEditingController();
TextEditingController protocolOrderIdController = TextEditingController();
TextEditingController protocolWorkerController = TextEditingController();

// Card Details
TextEditingController title = TextEditingController();
TextEditingController description = TextEditingController();
TextEditingController client = TextEditingController();
TextEditingController worker = TextEditingController();
TextEditingController completed = TextEditingController();
TextEditingController orderId = TextEditingController();

TextEditingController finishedTitle = TextEditingController();
TextEditingController finishedDescription = TextEditingController();
TextEditingController finishedClient = TextEditingController();
TextEditingController finishedWorker = TextEditingController();
TextEditingController finishedCompleted = TextEditingController();
TextEditingController finishedOrderId = TextEditingController();
int homeIndex = 0;
int finishedHomeIndex = 0;
bool finishedCardDetails = false;
bool readOnly = true;
String newTitle = '';
String newDescription = '';

// New Card
TextEditingController newCardTitle = TextEditingController();
TextEditingController newCardDescription = TextEditingController();

bool autoRefresh = true;
Duration refrestDuration = const Duration(seconds: 7);

// Dev Mode
bool devMode = false;

// Userdata Variables
String displayName = '';
String email = '';
String newDisplayName = '';
String newEmail = '';
String newPassword = '';

TextEditingController displayNameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
String falseLoginCode = '';
User? user;

//DB Connectiondata
String dbHost = 'nipotino2804.de';
int dbPort = 3306;
String dbUser = 'servio_user';
String dbPassword = 'hywbBMc6c5nfRR';
String dbName = 'servio';
