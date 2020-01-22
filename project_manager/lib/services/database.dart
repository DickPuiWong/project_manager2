import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/models/user.dart';

class DatabaseService {
  final CollectionReference projectCollection =
      Firestore.instance.collection('projects');

  List<Project> _projectsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Project(
        projID: doc.data['ID'] ?? 0,
        budget: (doc.data['budget']).toDouble() ?? 0.00,
        spentBudget: (doc.data['spent budget']).toDouble() ?? 0.00,
        projname: doc.data['name'] ?? '',
        location: doc.data['location'] ?? '',
        completion: (doc.data['completion']).toDouble() ?? 0,
        adhesiveTotalLitre:
            (doc.data['total adhesive litres']).toDouble() ?? 0.0,
        adhesiveUsedLitre: (doc.data['used adhesive litres']).toDouble() ?? 0.0,
        adhesivePrice: (doc.data['adhesive price']).toDouble() ?? 0.0,
        abrasiveTotalWeight:
            (doc.data['total abrasive weight']).toDouble() ?? 0.0,
        abrasiveUsedWeight:
            (doc.data['used abrasive weight']).toDouble() ?? 0.0,
        abrasivePrice: (doc.data['abrasive price']).toDouble() ?? 0.0,
        paintTotalLitre: (doc.data['total paint litres']).toDouble() ?? 0.0,
        paintUsedLitre: (doc.data['used paint litres']).toDouble() ?? 0.0,
        paintPrice: (doc.data['paint price']).toDouble() ?? 0.0,
        totalSurfaceAreaB:
            (doc.data['total area needed blasting']).toDouble() ?? 0.0,
        blastedArea: (doc.data['blasted area']).toDouble() ?? 0.0,
        totalSurfaceAreaP:
            (doc.data['total area needed painting']).toDouble() ?? 0.0,
        paintedArea: (doc.data['painted area']).toDouble() ?? 0.0,
        userAssigned: doc.data['users assigned'] ?? [],
        blastPot: (doc.data['blast pot']).toDouble() ?? 0.0,
        blastPotList: doc.data['blast pot list'] ?? {},
      );
    }).toList();
  }

  Stream<List<Project>> get projects {
    return projectCollection.snapshots().map(_projectsFromSnapshot);
  }
}

class ProjectDatabaseService {
  final String projID;
  ProjectDatabaseService({this.projID});

  final CollectionReference projectCollection =
      Firestore.instance.collection('projects');

  Project _projectFromSnapshot(DocumentSnapshot snapshot) {
    return Project(
      projID: snapshot.data['ID'],
      budget: (snapshot.data['budget']).toDouble(),
      spentBudget: (snapshot.data['spent budget']).toDouble(),
      projname: snapshot.data['name'],
      location: snapshot.data['location'],
      completion: (snapshot.data['completion']).toDouble(),
      adhesiveTotalLitre: (snapshot.data['total adhesive litres']).toDouble(),
      adhesiveUsedLitre: (snapshot.data['used adhesive litres']).toDouble(),
      adhesivePrice: (snapshot.data['adhesive price']).toDouble(),
      abrasiveTotalWeight: (snapshot.data['total abrasive weight']).toDouble(),
      abrasiveUsedWeight: (snapshot.data['used abrasive weight']).toDouble(),
      abrasivePrice: (snapshot.data['abrasive price']).toDouble(),
      paintTotalLitre: (snapshot.data['total paint litres']).toDouble(),
      paintUsedLitre: (snapshot.data['used paint litres']).toDouble(),
      paintPrice: (snapshot.data['paint price']).toDouble(),
      totalSurfaceAreaB:
          (snapshot.data['total area needed blasting']).toDouble(),
      blastedArea: (snapshot.data['blasted area']).toDouble(),
      totalSurfaceAreaP:
          (snapshot.data['total area needed painting']).toDouble(),
      paintedArea: (snapshot.data['painted area']).toDouble(),
      userAssigned: snapshot.data['users assigned'],
      blastPot: (snapshot.data['blast pot']).toDouble(),
      blastPotList: snapshot.data['blast pot list'],
    );
  }

  Stream<Project> get project {
    return projectCollection
        .document(projID)
        .snapshots()
        .map(_projectFromSnapshot);
  }
}

class UserDataService {
  final String uid;
  UserDataService({this.uid});

  final CollectionReference userCollection =
      Firestore.instance.collection('UserData');

  Future updateUserData(int permissionType, List projList) async {
    return await userCollection.document(uid).setData({
      'ID': uid,
      'Username': 'Demoman',
      'permissionType': permissionType,
      'projList': projList,
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: snapshot.data['ID'],
      userName: snapshot.data['Username'],
      permissionType: snapshot.data['permissionType'],
      projList: snapshot.data['projList'],
    );
  }

  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}

class UsersDatabaseService {
  final CollectionReference userCollection =
      Firestore.instance.collection('UserData');

  List<UserData> _usersFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserData(
        uid: doc.data['ID'] ?? 0,
        userName: doc.data['Username'] ?? '',
        permissionType: doc.data['permissionType'] ?? '',
        projList: doc.data['projList'] ?? [],
      );
    }).toList();
  }

  Stream<List<UserData>> get usersData {
    return userCollection.snapshots().map(_usersFromSnapshot);
  }
}
