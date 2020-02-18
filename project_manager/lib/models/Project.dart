// Name : Project.dart
// Purpose : all the variables that is needed in Project class
// Function : This file contains all the declared and initialised variables for Project, BlastPot, BudgetType, ProgressType  classes

class Project {
  final String projID;
  final String projname;
  final String location;
  final double adhesiveTotalLitre;
  final double adhesiveUsedLitre;
  final double abrasiveTotalWeight;
  final double abrasiveUsedWeight;
  final double paintTotalLitre;
  final double paintUsedLitre;
  final double totalSurfaceAreaB;
  final double blastedArea;
  final double totalSurfaceAreaP;
  final double paintedArea;
  final List projectSupervisor;
  final List userAssigned;
  final double blastPot;
  final Map perFill;
  final Map blastPotList;
  final Map budgetList;
  final Map progressesTracked;
  var date;

  Project({
    this.projID,
    this.projname,
    this.location,
    this.adhesiveTotalLitre,
    this.adhesiveUsedLitre,
    this.abrasiveTotalWeight,
    this.abrasiveUsedWeight,
    this.paintTotalLitre,
    this.paintUsedLitre,
    this.totalSurfaceAreaB,
    this.blastedArea,
    this.totalSurfaceAreaP,
    this.paintedArea,
    this.userAssigned,
    this.projectSupervisor,
    this.blastPot,
    this.perFill,
    this.blastPotList,
    this.budgetList,
    this.progressesTracked,
    this.date,
  });
}

////////////////////////////////////////////////////////////////////////////////

class BlastPot {
  final int num;
  final double usedAbrasive;
  final double usedAdhesive;
  final double usedHours;

  BlastPot({
    this.num,
    this.usedAbrasive,
    this.usedAdhesive,
    this.usedHours,
  });
}

////////////////////////////////////////////////////////////////////////////////

class BudgetType {
  final String name;
  final double spent;
  final double estimate;

  BudgetType({
    this.name,
    this.spent,
    this.estimate,
  });
}

////////////////////////////////////////////////////////////////////////////////

class ProgressType {
  final String name;
  final double done;
  final double total;

  ProgressType({
    this.name,
    this.done,
    this.total,
  });
}
