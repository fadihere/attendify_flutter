import 'package:auto_route/auto_route.dart';

import '../../../injection_container.dart';
import 'app_router.gr.dart';

final router = sl<AppRouter>();

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(initial: true, page: SplashRoute.page),
        AutoRoute(page: UserSelectionRoute.page),
        //*Employee

        AutoRoute(page: SigninEmpRoute.page),
        AutoRoute(page: VerificationEmpRoute.page),
        AutoRoute(page: ForgotPasswordEmpRoute.page),
        AutoRoute(page: ResetPasswordEmpRoute.page),
        AutoRoute(page: ChangePasswordEmpRoute.page),
        AutoRoute(page: ChangePhoneNumRoute.page),
        AutoRoute(page: LeaveDashboardRoute.page),
        AutoRoute(page: NotificationsEmpRoute.page),

        AutoRoute(
          path: '/',
          page: BaseEmpRoute.page,
          children: [
            // RedirectRoute(path: '*', redirectTo: BaseEmpRoute.name),
            AutoRoute(
              initial: true,
              path: HomeEmpRoute.name,
              page: HomeEmpRoute.page,
            ),
            AutoRoute(
              path: LogsRoute.name,
              page: LogsRoute.page,
            ),
            AutoRoute(
              path: SettingsEmpRoute.name,
              page: SettingsEmpRoute.page,
            ),
          ],
        ),
        AutoRoute(page: SetOfficeHourRoute.page),

        //*Employer
        AutoRoute(page: AddOrganizationRoute.page),
        AutoRoute(page: SigninEmrRoute.page),
        AutoRoute(page: VerificationEmrRoute.page),
        AutoRoute(page: NotificationsRoute.page),
        AutoRoute(page: LeavePeriodRoute.page),
        AutoRoute(page: LeaveCategoryRoute.page),
        AutoRoute(page: LeaveRequestRoute.page),
        AutoRoute(page: AdmReportRoute.page),
        AutoRoute(page: AdmAddNewLocationRoute.page),
        AutoRoute(page: SetOfficeHourRoute.page),
        AutoRoute(page: AddEmployeeRoute.page),
        AutoRoute(page: ConfirmLocationRoute.page),
        AutoRoute(page: AssignLocationRoute.page),
        AutoRoute(page: PlacePicker.page),
        AutoRoute(page: TotalEmployeeRoute.page),
        AutoRoute(page: SetupPin1Route.page),
        AutoRoute(page: SetupPin2Route.page),
        AutoRoute(page: SetupPin3Route.page),
        AutoRoute(page: TeamReportRoute.page),
        AutoRoute(page: ChangeTeamPhoneRoute.page),
        AutoRoute(page: ChangeEmailRoute.page),
        AutoRoute(page: CheckInRoute.page),
        AutoRoute(page: AdmPdfPreviewRoute.page),
        AutoRoute(page: AdmAttendenceDetailRoute.page),
        AutoRoute(page: AttendenceDetailLocationRoute.page),
        AutoRoute(page: SetWorkTimeRoute.page),
        AutoRoute(page: NotOnLocationDetailRoute.page),

        AutoRoute(
          path: '/',
          page: BaseEmrRoute.page,
          children: [
            // RedirectRoute(path: '', redirectTo: HomeRoute.name),
            AutoRoute(
              initial: true,
              page: AdmHomeRoute.page,
            ),
            AutoRoute(
              page: AdmSettingsRoute.page,
            ),
            AutoRoute(
              page: TeamEmrRoute.page,
            ),
          ],
        ),
      ];
}
