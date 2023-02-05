import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:todo/features/task/data/datasource/task_local_data_source.dart';
import 'package:todo/features/task/data/datasource/task_remote_data_source.dart';
import 'package:todo/features/task/data/model/task_info_model.dart';
import 'package:todo/features/task/data/repository/task_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/features/task/domain/usecases/create_task.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';

class MockLocalDataSource extends Mock implements ITaskLocalDataSource {}

class MockRemoteDataSource extends Mock implements ITaskRemoteDataSource {}

void main() {
  MockLocalDataSource mockLocalDataSource;
  MockRemoteDataSource? mockRemoteDataSource;
  TaskRepository? taskRepository;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();

    taskRepository = TaskRepository(
        taskRemoteDataSource: mockRemoteDataSource!,
        taskLocalDataSource: mockLocalDataSource);
  });

  group("Testing TaskRepository", () {
    test("Should create task and return the created Task", () async {
      const CreateTaskParams createTaskParams = CreateTaskParams(
          creatorInfo: UserInfo(id: "", fullName: "", profilePic: ""),
          taskName: "TaskName",
          taskDescription: "TaskDescription",
          users: [UserInfo(id: "", fullName: "", profilePic: "")]);

      final TaskInfoModel taskInfoModel = TaskInfoModel(
          taskId: "",
          taskName: createTaskParams.taskName,
          taskDescription: createTaskParams.taskDescription,
          isCompleted: false,
          totalHours: Duration.zero,
          createdOn: DateTime.now(),
          completedOn: null,
          assignedTo: createTaskParams.users);

      // arrange
      when(mockRemoteDataSource!.createTask(createTaskParams))
          .thenAnswer((_) => Future.value(taskInfoModel));

      // act
      final result = await taskRepository!.createTask(createTaskParams);
      // assert
      verify(taskRepository!.createTask(createTaskParams));
      expect(result, Right(taskInfoModel));
    });
  });
}
