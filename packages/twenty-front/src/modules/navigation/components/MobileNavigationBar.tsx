import { currentWorkspaceState } from '@/auth/states/currentWorkspaceState';
import { useCommandMenu } from '@/command-menu/hooks/useCommandMenu';
import { isCommandMenuOpenedState } from '@/command-menu/states/isCommandMenuOpenedState';
import { WorkspaceFavorites } from '@/favorites/components/WorkspaceFavorites';
import { NavigationDrawerHeader } from '@/ui/navigation/navigation-drawer/components/NavigationDrawerHeader';
import { isNavigationDrawerExpandedState } from '@/ui/navigation/states/isNavigationDrawerExpanded';
import { useRecoilState, useRecoilValue } from 'recoil';
import {
  getImageAbsoluteURI,
  IconSearch,
  IconSettings,
  NavigationBarItem,
} from 'twenty-ui';
import { useIsSettingsPage } from '../hooks/useIsSettingsPage';
import { currentMobileNavigationDrawerState } from '../states/currentMobileNavigationDrawerState';

import { CurrentWorkspaceMemberFavorites } from '@/favorites/components/CurrentWorkspaceMemberFavorites';
import { NavigationDrawerOpenedSection } from '@/object-metadata/components/NavigationDrawerOpenedSection';
import { NavigationDrawerSectionForObjectMetadataItemsWrapper } from '@/object-metadata/components/NavigationDrawerSectionForObjectMetadataItemsWrapper';
import { NavigationDrawerItem } from '@/ui/navigation/navigation-drawer/components/NavigationDrawerItem';
import { useIsMobile } from '@/ui/utilities/responsive/hooks/useIsMobile';
import { useIsFeatureEnabled } from '@/workspace/hooks/useIsFeatureEnabled';
import styled from '@emotion/styled';

const StyledNavigationWrapper = styled.div`
  display: flex;
  flex-direction: row;
  align-items: center;
  width: 90%;
  margin: auto;
  overflow-x: auto;
  padding: ${({ theme }) => theme.spacing(3)};
  z-index: 1001;
`;

const StyledNavigationItem = styled.div``;

export const MobileNavigationBar = () => {
  const [isCommandMenuOpened] = useRecoilState(isCommandMenuOpenedState);
  const { closeCommandMenu, openCommandMenu } = useCommandMenu();
  const isSettingsPage = useIsSettingsPage();
  const [isNavigationDrawerExpanded, setIsNavigationDrawerExpanded] =
    useRecoilState(isNavigationDrawerExpandedState);
  const [currentMobileNavigationDrawer, setCurrentMobileNavigationDrawer] =
    useRecoilState(currentMobileNavigationDrawerState);

  const currentWorkspace = useRecoilValue(currentWorkspaceState);

  const logo =
    (currentWorkspace?.logo && getImageAbsoluteURI(currentWorkspace.logo)) ??
    undefined;
  const title = currentWorkspace?.displayName ?? undefined;

  const activeItemName = isNavigationDrawerExpanded
    ? currentMobileNavigationDrawer
    : isCommandMenuOpened
      ? 'search'
      : isSettingsPage
        ? 'settings'
        : 'main';

  const isMobile = useIsMobile();

  const isWorkspaceFavoriteEnabled = useIsFeatureEnabled(
    'IS_WORKSPACE_FAVORITE_ENABLED',
  );

  return (
    <>
      <StyledNavigationWrapper>
        <StyledNavigationItem>
          <NavigationDrawerHeader
            visible={isMobile}
            name={title}
            logo={logo}
            showCollapseButton={false}
          />
        </StyledNavigationItem>
        <StyledNavigationItem>
          <NavigationDrawerItem
            label="Search"
            Icon={IconSearch}
            mobileNavigationDrawer={true}
            onClick={() => {
              if (!isCommandMenuOpened) {
                openCommandMenu();
              }
              setIsNavigationDrawerExpanded(false);
            }}
            // keyboard={['⌘', 'K']}
          />
        </StyledNavigationItem>
        <StyledNavigationItem>
          <NavigationBarItem
            key={'settings'}
            Icon={IconSettings}
            isActive={activeItemName === 'settings'}
            onClick={() => {
              closeCommandMenu();
              setIsNavigationDrawerExpanded(
                (previousIsOpen) =>
                  activeItemName !== 'settings' || !previousIsOpen,
              );
              setCurrentMobileNavigationDrawer('settings');
            }}
          />
        </StyledNavigationItem>

        {isWorkspaceFavoriteEnabled && (
          <StyledNavigationItem>
            <NavigationDrawerOpenedSection mobileNavigationDrawer={true} />
          </StyledNavigationItem>
        )}

        <StyledNavigationItem>
          <CurrentWorkspaceMemberFavorites mobileNavigationDrawer={true} />
        </StyledNavigationItem>

        {isWorkspaceFavoriteEnabled ? (
          <StyledNavigationItem>
            <WorkspaceFavorites mobileNavigationDrawer={true} />
          </StyledNavigationItem>
        ) : (
          <NavigationDrawerSectionForObjectMetadataItemsWrapper
            mobileNavigationDrawer={true}
            isRemote={false}
          />
        )}

        <StyledNavigationItem>
          <NavigationDrawerSectionForObjectMetadataItemsWrapper
            mobileNavigationDrawer={true}
            isRemote={true}
          />
        </StyledNavigationItem>
      </StyledNavigationWrapper>
    </>
  );
};
