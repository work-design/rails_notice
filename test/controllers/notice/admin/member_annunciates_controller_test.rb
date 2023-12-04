require 'test_helper'
class Notice::Admin::MemberAnnunciatesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @member_annunciate = member_annunciates(:one)
  end

  test 'index ok' do
    get url_for(controller: 'notice/admin/member_annunciates')

    assert_response :success
  end

  test 'new ok' do
    get url_for(controller: 'notice/admin/member_annunciates')

    assert_response :success
  end

  test 'create ok' do
    assert_difference('MemberAnnunciate.count') do
      post(
        url_for(controller: 'notice/admin/member_annunciates', action: 'create'),
        params: { member_annunciate: { annunciated_at: @notice_admin_member_annunciate.annunciated_at, notifications_count: @notice_admin_member_annunciate.notifications_count, state: @notice_admin_member_annunciate.state } },
        as: :turbo_stream
      )
    end

    assert_response :success
  end

  test 'show ok' do
    get url_for(controller: 'notice/admin/member_annunciates', action: 'show', id: @member_annunciate.id)

    assert_response :success
  end

  test 'edit ok' do
    get url_for(controller: 'notice/admin/member_annunciates', action: 'edit', id: @member_annunciate.id)

    assert_response :success
  end

  test 'update ok' do
    patch(
      url_for(controller: 'notice/admin/member_annunciates', action: 'update', id: @member_annunciate.id),
      params: { member_annunciate: { annunciated_at: @notice_admin_member_annunciate.annunciated_at, notifications_count: @notice_admin_member_annunciate.notifications_count, state: @notice_admin_member_annunciate.state } },
      as: :turbo_stream
    )

    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('MemberAnnunciate.count', -1) do
      delete url_for(controller: 'notice/admin/member_annunciates', action: 'destroy', id: @member_annunciate.id), as: :turbo_stream
    end

    assert_response :success
  end

end
