{**
 * Информация о пользователе
 *
 * @param object $user
 * @param array  usersInvited
 * @param object invitedByUser
 * @param array  blogsJoined
 * @param array  blogsModerate
 * @param array  blogsAdminister
 * @param array  blogsCreated
 * @param array  usersFriend
 *}

{component_define_params params=[ 'blogsAdminister', 'blogsCreated', 'blogsJoined', 'blogsModerate', 'friends', 'invitedByUser', 'user', 'usersInvited', 'mods', 'classes', 'attributes' ]}

{$session = $user->getSession()}
{$geoTarget = $user->getGeoTarget()}

{* @hook Начало информации о пользователе *}
{hook run='user_info_begin' user=$user}

{**
 * О себе
 *}
{if $user->getProfileAbout()}
    {capture 'user_info_about'}
        <div class="ls-text">
            {$user->getProfileAbout()}
        </div>
    {/capture}

    {component 'user' template='info-group' title={lang name='user.profile.about.title'} html=$smarty.capture.user_info_about}
{/if}

<div class='user-info-group-conteiner'>  
    <div class='user-info-group-left'>
        {**
         * Контакты
         *}
        {$items = []}
        {$userfields = $user->getUserFieldValues(true, array('contact'))}

        {foreach $userfields as $field}
            {$items[] = [
                'label'   => $field->getTitle()|escape,
                'content' => $field->getValue(true, true)
            ]}
        {/foreach}

        {**
         * Соц. сети
         *}
        {$userfields = $user->getUserFieldValues(true, array('social'))}

        {foreach $userfields as $field}
            {$items[] = [
                'label'   => $field->getTitle()|escape,
                'content' => $field->getValue(true, true)
            ]}
        {/foreach}

        {component 'user' template='info-group' name='contact' title={lang name='user.profile.contact'} items=$items}

    </div>


    <div class='user-info-group-right'>
        {**
         * Личное
         *}
        {$items = []}
        {$userfields = $user->getUserFieldValues(true, array(''))}

        {* Пол *}
        {if $user->getProfileSex() != 'other'}
            {$items[] = [
                'label'   => {lang name='user.profile.personal.gender'},
                'content' => "{if $user->getProfileSex() == 'man'}{lang name='user.profile.personal.gender_male'}{else}{lang name='user.profile.personal.gender_female'}{/if}"
            ]}
        {/if}

        {* День рождения *}
        {if $user->getProfileBirthday()}
            {$items[] = [
                'label'   => {lang name='user.profile.personal.birthday'},
                'content' => {date_format date=$user->getProfileBirthday() format="j F Y" notz=true}
            ]}
        {/if}

        {* Местоположение *}
        {if $geoTarget}
            {capture 'info_private_geo'}
                <span itemprop="address" itemscope itemtype="http://data-vocabulary.org/Address">
                    {if $geoTarget->getCountryId()}
                        <span itemprop="country-name">{$user->getProfileCountry()|escape}</span>{if $geoTarget->getCityId()},{/if}
                    {/if}

                    {if $geoTarget->getCityId()}
                        <span itemprop="locality">{$user->getProfileCity()|escape}</span>
                    {/if}
                </span>
            {/capture}

            {$items[] = [
                'label'   => {lang name='user.profile.personal.place'},
                'content' => $smarty.capture.info_private_geo
            ]}
        {/if}



        {component 'user' template='info-group' title={lang name='user.settings.profile.generic'} items=$items}





        {**
         * Активность
         *}
        {$items = []}

        {* Кто пригласил пользователя *}
        {if $invitedByUser}
            {$items[] = [
                'label'   => {lang name='user.profile.activity.invited_by'},
                'content' => "<a href=\"{$invitedByUser->getUserWebPath()}\">{$invitedByUser->getDisplayName()}</a>"
            ]}
        {/if}

        {* Приглашенные пользователем *}
        {if $usersInvited}
            {$users = ''}

            {foreach $usersInvited as $userInvited}
                {$users = $users|cat:"<a href=\"{$userInvited->getUserWebPath()}\">{$userInvited->getDisplayName()}</a>&nbsp;"}
            {/foreach}

            {$items[] = [
                'label'   => {lang name='user.profile.activity.invited'},
                'content' => $users
            ]}
        {/if}

        {* Блоги созданные пользователем *}
        {if $blogsCreated}
            {$blogs = ''}

            {foreach $blogsCreated as $blog}
                {$blogs = $blogs|cat:"<a href=\"{$blog->getUrlFull()}\">{$blog->getTitle()|escape}</a>{if ! $blog@last}, {/if}"}
            {/foreach}

            {$items[] = [
                'label'   => {lang name='user.profile.activity.blogs_created'},
                'content' => $blogs
            ]}
        {/if}

        {* Блоги администрируемые пользователем *}
        {if $blogsAdminister}
            {$blogs = ''}

            {foreach $blogsAdminister as $blogUser}
                {$blog = $blogUser->getBlog()}
                {$blogs = $blogs|cat:"<a href=\"{$blog->getUrlFull()}\">{$blog->getTitle()|escape}</a>{if ! $blogUser@last}, {/if}"}
            {/foreach}

            {$items[] = [
                'label'   => {lang name='user.profile.activity.blogs_admin'},
                'content' => $blogs
            ]}
        {/if}

        {* Блоги модерируемые пользователем *}
        {if $blogsModerate}
            {$blogs = ''}

            {foreach $blogsModerate as $blogUser}
                {$blog = $blogUser->getBlog()}
                {$blogs = $blogs|cat:"<a href=\"{$blog->getUrlFull()}\">{$blog->getTitle()|escape}</a>{if ! $blogUser@last}, {/if}"}
            {/foreach}

            {$items[] = [
                'label'   => {lang name='user.profile.activity.blogs_mod'},
                'content' => $blogs
            ]}
        {/if}

        {* Блоги в которые вступил пользователь *}
        {if $blogsJoined}
            {$blogs = ''}

            {foreach $blogsJoined as $blogUser}
                {$blog = $blogUser->getBlog()}
                {$blogs = $blogs|cat:"<a href=\"{$blog->getUrlFull()}\">{$blog->getTitle()|escape}</a>{if ! $blogUser@last}, {/if}"}
            {/foreach}

            {$items[] = [
                'label'   => {lang name='user.profile.activity.blogs_joined'},
                'content' => $blogs
            ]}
        {/if}

        {* Дата регистрации *}
        {$items[] = [
            'label'   => {lang name='user.date_registration'},
            'content' => {date_format date=$user->getDateRegister()}
        ]}

        {* Дата последнего визита *}
        {if $session}
            {$items[] = [
                'label'   => {lang name='user.date_last_session'},
                'content' => {date_format date=$session->getDateLast()}
            ]}
        {/if}

        {component 'user' template='info-group' name='activity' title={lang name='user.profile.activity.title'} items=$items}



        {**
         * Друзья
         *}
        {if $friends}
            {capture 'user_info_friends'}
                {component 'user' template='avatar-list' users=$friends}
            {/capture}

            {component 'user' template='info-group'
                title = "<a href=\"{$user->getUserWebPath()}friends/\">{$aLang.user.friends.title}</a> ({$iCountFriendsUser})"
                html  = $smarty.capture.user_info_friends}
        {/if}
    </div>
</div>

{**
 * Стена
 *}
{capture 'user_info_wall'}
    {insert name='block' block='wall' params=[
        'classes' => 'js-wall-default',
        'user_id' => $user->getId()
    ]}
{/capture}

{component 'user' template='info-group' name='wall' title={lang name='wall.title'} html=$smarty.capture.user_info_wall}



{* @hook Конец информации о пользователе *}
{hook run='user_info_end' user=$user}