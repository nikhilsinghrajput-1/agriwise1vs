import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/src/core/network/api_client.dart';
import 'package:myapp/src/core/network/connectivity_service.dart';
import 'package:myapp/src/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:myapp/src/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:myapp/src/features/weather/domain/repositories/weather_repository.dart';
import 'package:myapp/src/features/weather/domain/usecases/get_weather_data.dart';
import 'package:myapp/src/features/home/data/datasources/advisory_remote_data_source.dart';
import 'package:myapp/src/features/home/data/repositories/advisory_repository_impl.dart';
import 'package:myapp/src/features/home/domain/repositories/advisory_repository.dart';
import 'package:myapp/src/features/home/domain/usecases/get_advisory_data.dart';
import 'package:myapp/src/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:myapp/src/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:myapp/src/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:myapp/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:myapp/src/features/authentication/domain/usecases/get_current_user.dart';
import 'package:myapp/src/features/authentication/domain/usecases/reset_password.dart';
import 'package:myapp/src/features/authentication/domain/usecases/sign_in.dart';
import 'package:myapp/src/features/authentication/domain/usecases/sign_out.dart';
import 'package:myapp/src/features/authentication/domain/usecases/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/src/features/crops/data/repositories/crop_repository_impl.dart';
import 'package:myapp/src/features/crops/domain/repositories/crop_repository.dart';
import 'package:myapp/src/features/crops/presentation/bloc/crop_bloc.dart';
import 'package:myapp/src/core/services/firebase_service.dart';

final getIt = GetIt.instance;

/// A simple dependency injection container
class DependencyInjection {
  static final DependencyInjection _instance = DependencyInjection._internal();
  
  factory DependencyInjection() => _instance;
  
  DependencyInjection._internal();
  
  // Core dependencies
  late final ApiClient _apiClient;
  late final ConnectivityService _connectivityService;
  late final SharedPreferences _sharedPreferences;
  
  // Weather feature dependencies
  late final WeatherRemoteDataSource _weatherRemoteDataSource;
  late final WeatherRepository _weatherRepository;
  late final GetWeatherData _getWeatherData;
  
  // Advisory feature dependencies
  late final AdvisoryRemoteDataSource _advisoryRemoteDataSource;
  late final AdvisoryRepository _advisoryRepository;
  late final GetAdvisoryData _getAdvisoryData;
  
  // Authentication feature dependencies
  late final AuthLocalDataSource _authLocalDataSource;
  late final AuthRemoteDataSource _authRemoteDataSource;
  late final AuthRepository _authRepository;
  late final SignIn _signIn;
  late final SignUp _signUp;
  late final SignOut _signOut;
  late final GetCurrentUser _getCurrentUser;
  late final ResetPassword _resetPassword;

  // Crops feature dependencies
  late final FirebaseService _firebaseService;
  
  /// Initializes all dependencies
  Future<void> init() async {
    // Initialize core dependencies
    _sharedPreferences = await SharedPreferences.getInstance();
    _apiClient = ApiClient(
      client: http.Client(),
      baseUrl: 'https://api.openweathermap.org/data/2.5',
    );
    _connectivityService = ConnectivityService();
    // Initialize Firebase
    await Firebase.initializeApp();
    _firebaseService = FirebaseService();
    
    // Initialize weather feature dependencies
    _weatherRemoteDataSource = WeatherRemoteDataSource(
      apiClient: _apiClient,
    );
    _weatherRepository = WeatherRepositoryImpl(
      remoteDataSource: _weatherRemoteDataSource,
      connectivityService: _connectivityService,
    );
    _getWeatherData = GetWeatherData(
      repository: _weatherRepository,
    );
    
    // Initialize advisory feature dependencies
    _advisoryRemoteDataSource = AdvisoryRemoteDataSource(
      apiClient: _apiClient,
    );
    _advisoryRepository = AdvisoryRepositoryImpl(
      remoteDataSource: _advisoryRemoteDataSource,
      connectivityService: _connectivityService,
    );
    _getAdvisoryData = GetAdvisoryData(
      repository: _advisoryRepository,
    );
    
    // Initialize authentication feature dependencies
    _authLocalDataSource = AuthLocalDataSource(
      sharedPreferences: _sharedPreferences,
    );
    _authRemoteDataSource = AuthRemoteDataSource(
      apiClient: _apiClient,
    );
    _authRepository = AuthRepositoryImpl(
      remoteDataSource: _authRemoteDataSource,
      localDataSource: _authLocalDataSource,
      connectivityService: _connectivityService,
    );
    _signIn = SignIn(repository: _authRepository);
    _signUp = SignUp(repository: _authRepository);
    _signOut = SignOut(repository: _authRepository);
    _getCurrentUser = GetCurrentUser(repository: _authRepository);
    _resetPassword = ResetPassword(repository: _authRepository);

    // Repositories
    getIt.registerLazySingleton<CropRepository>(
      () => CropRepositoryImpl(_firebaseService),
    );

    // BLoCs
    getIt.registerFactoryAsync<CropBloc>(() async {
      final userResult = await _getCurrentUser.execute();
      final userId = userResult.data?.id ?? 'default_user_id';
      return CropBloc(
        getIt<CropRepository>(),
        userId,
      );
    });
  }

  // Getters for dependencies
  ApiClient get apiClient => _apiClient;
  ConnectivityService get connectivityService => _connectivityService;
  WeatherRemoteDataSource get weatherRemoteDataSource => _weatherRemoteDataSource;
  WeatherRepository get weatherRepository => _weatherRepository;
  GetWeatherData get getWeatherData => _getWeatherData;
  GetAdvisoryData get getAdvisoryData => _getAdvisoryData;
  AuthRepository get authRepository => _authRepository;
  SignIn get signIn => _signIn;
  SignUp get signUp => _signUp;
  SignOut get signOut => _signOut;
  GetCurrentUser get getCurrentUser => _getCurrentUser;
  ResetPassword get resetPassword => _resetPassword;
}
