abstract class ToDoAppStates {}

class ToDoAppInitializeState extends ToDoAppStates {}
class ToDoAppLoadingState extends ToDoAppStates {}


class AppGetUserSuccessfulState extends ToDoAppStates {}
class AppGetUserErrorState extends ToDoAppStates {
  final String? e ;
  AppGetUserErrorState(this.e);
}


class ChangeBottomNavigatorState extends ToDoAppStates {}
class NewTaskState extends ToDoAppStates {}


class CreateNewTaskLoadingState extends ToDoAppStates {}
class CreateNewTaskSuccessfulState extends ToDoAppStates {}
class CreateNewTasErrorState extends ToDoAppStates {
  final String? e ;
  CreateNewTasErrorState(this.e);
}


class GetAllTasksLoadingState extends ToDoAppStates {}
class GetAllTasksSuccessfulState extends ToDoAppStates {}

class GetSubTasksLoadingState extends ToDoAppStates {}
class GetSubTasksSuccessfulState extends ToDoAppStates {}
class GetSubTasksErrorState extends ToDoAppStates {
  final String? e ;
  GetSubTasksErrorState(this.e);
}


class UpDateCompleteTaskSuccessfulState extends ToDoAppStates {}
class UpDateCompleteTaskErrorState extends ToDoAppStates {}

class UpDateCompleteSubTaskSuccessfulState extends ToDoAppStates {}
class UpDateCompleteSubTaskErrorState extends ToDoAppStates {}

class EditTaskLoadingState extends ToDoAppStates {}
class EditTaskSuccessfulState extends ToDoAppStates {}
class EditTaskErrorState extends ToDoAppStates {}

class EditSubTaskLoadingState extends ToDoAppStates {}
class EditSubTaskSuccessfulState extends ToDoAppStates {}
class EditSubTaskErrorState extends ToDoAppStates {}

class DeleteTaskSuccessfulState extends ToDoAppStates {}
class DeleteTaskErrorState extends ToDoAppStates {}

class DeleteSubTaskSuccessfulState extends ToDoAppStates {}
class DeleteSubTaskErrorState extends ToDoAppStates {}

class AddSubTaskLoadingState extends ToDoAppStates {}
class AddSubTaskSuccessfulState extends ToDoAppStates {}
class AddSubTasErrorState extends ToDoAppStates {
  final String? e ;
  AddSubTasErrorState(this.e);
}


class FilterTaskLoadingState extends ToDoAppStates {}
class FilterTaskSuccessfulState extends ToDoAppStates {}



