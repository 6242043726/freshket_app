import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:freshket_app/core/connection/network_info.dart';
import 'package:freshket_app/core/constants/constants.dart';
import 'package:freshket_app/features/shopping/data/datasources/remote/product_data_source.dart';
import 'package:freshket_app/features/shopping/data/repositories/cart_repository_impl.dart';
import 'package:freshket_app/features/shopping/data/repositories/product_repository_impl.dart';
import 'package:freshket_app/features/shopping/domain/repositories/cart_repository.dart';
import 'package:freshket_app/features/shopping/domain/repositories/product_repository.dart';
import 'package:freshket_app/features/shopping/domain/usecases/checkout.dart';
import 'package:freshket_app/features/shopping/domain/usecases/get_product.dart';
import 'package:freshket_app/features/shopping/domain/usecases/get_recommended_product.dart';
import 'package:freshket_app/features/shopping/presentation/provider/cart_provider.dart';
import 'package:freshket_app/features/shopping/presentation/provider/product_provider.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

final dio = Dio(BaseOptions(
  baseUrl: ApiConfig.baseUrl,
));

void setupLocator() {

  getIt.registerLazySingleton<ProductDataSource>(
    () => ProductDataSourceImpl(dio: dio),
  );

  getIt.registerLazySingleton<DataConnectionChecker>(() => DataConnectionChecker());

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt<DataConnectionChecker>()));

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(networkInfo: getIt<NetworkInfo>(),productDataSource: getIt<ProductDataSource>()),
  );

  getIt.registerLazySingleton<GetProducts>(
    () => GetProducts(getIt<ProductRepository>()),
  );

   getIt.registerLazySingleton<GetRecommendedProducts>(
    () => GetRecommendedProducts(getIt<ProductRepository>()),
  );

  getIt.registerFactory<ProductProvider>(
    () => ProductProvider(
      getIt<GetProducts>(),
      getIt<GetRecommendedProducts>(),
    ),
  );

  getIt.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(dio));

  getIt.registerLazySingleton<CheckoutUseCase>(() => CheckoutUseCase(getIt<CartRepository>()));

  getIt.registerFactory<CartProvider>(() => CartProvider(checkoutUseCase: getIt<CheckoutUseCase>()));
}
